/* WeChat's bundled Qt handles notification actions without checking their ID.
 * Keep the host bus (needed for its tray), but consume foreign notification
 * signals before Qt's filters see them. All state belongs to one connection.
 */
#define _GNU_SOURCE
#include <dbus/dbus.h>
#include <dlfcn.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#define SERVICE "org.freedesktop.Notifications"
#define PATH "/org/freedesktop/Notifications"
struct entry { dbus_uint32_t value; struct entry *next; };
struct state { struct entry *owned; pthread_mutex_t lock; };
static dbus_int32_t slot = -1;
static dbus_int32_t pending_slot = -1;
static pthread_once_t once = PTHREAD_ONCE_INIT;
static pthread_mutex_t init_lock = PTHREAD_MUTEX_INITIALIZER;

static void insert(struct entry **list, dbus_uint32_t value)
{
    for (struct entry *p = *list; p; p = p->next)
        if (p->value == value) return;
    struct entry *p = malloc(sizeof(*p));
    if (!p) abort();
    *p = (struct entry){ value, *list };
    *list = p;
}
static int contains(struct entry *list, dbus_uint32_t value)
{
    for (; list; list = list->next) if (list->value == value) return 1;
    return 0;
}
static int erase(struct entry **list, dbus_uint32_t value)
{
    for (; *list; list = &(*list)->next) {
        if ((*list)->value == value) {
            struct entry *p = *list;
            *list = p->next;
            free(p);
            return 1;
        }
    }
    return 0;
}
static void clear(struct entry **list)
{
    while (*list) erase(list, (*list)->value);
}
static int notify(DBusMessage *m)
{
    return dbus_message_is_method_call(m, SERVICE, "Notify") &&
        dbus_message_has_destination(m, SERVICE) && dbus_message_has_path(m, PATH);
}
static void remember(struct state *s, DBusMessage *m)
{
    dbus_uint32_t id;
    if (m && dbus_message_get_type(m) == DBUS_MESSAGE_TYPE_METHOD_RETURN &&
        dbus_message_get_args(m, NULL, DBUS_TYPE_UINT32, &id, DBUS_TYPE_INVALID))
        insert(&s->owned, id);
}
static DBusHandlerResult filter(DBusConnection *c, DBusMessage *m, void *data)
{
    (void)c;
    struct state *s = data;
    DBusHandlerResult result = DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
    pthread_mutex_lock(&s->lock);
    if (dbus_message_is_signal(m, DBUS_INTERFACE_DBUS, "NameOwnerChanged")) {
        const char *name, *old_owner, *new_owner;
        if (dbus_message_get_args(m, NULL, DBUS_TYPE_STRING, &name,
                DBUS_TYPE_STRING, &old_owner, DBUS_TYPE_STRING, &new_owner,
                DBUS_TYPE_INVALID) && !strcmp(name, SERVICE)) {
            clear(&s->owned);
        }
    }
    if (dbus_message_has_path(m, PATH) &&
        (dbus_message_is_signal(m, SERVICE, "ActionInvoked") ||
         dbus_message_is_signal(m, SERVICE, "ActivationToken") ||
         dbus_message_is_signal(m, SERVICE, "NotificationClosed"))) {
        DBusMessageIter it;
        dbus_uint32_t id = 0;
        if (dbus_message_iter_init(m, &it) &&
            dbus_message_iter_get_arg_type(&it) == DBUS_TYPE_UINT32)
            dbus_message_iter_get_basic(&it, &id);
        if (!id || !contains(s->owned, id)) result = DBUS_HANDLER_RESULT_HANDLED;
        if (dbus_message_has_member(m, "NotificationClosed")) erase(&s->owned, id);
    }
    pthread_mutex_unlock(&s->lock);
    return result;
}
static void destroy(void *data)
{
    struct state *s = data;
    clear(&s->owned);
    pthread_mutex_destroy(&s->lock);
    free(s);
}
static void allocate_slot(void)
{
    if (!dbus_connection_allocate_data_slot(&slot)) abort();
    if (!dbus_pending_call_allocate_data_slot(&pending_slot)) abort();
}
static struct state *state_for(DBusConnection *c)
{
    pthread_once(&once, allocate_slot);
    pthread_mutex_lock(&init_lock);
    struct state *s = dbus_connection_get_data(c, slot);
    if (!s) {
        s = calloc(1, sizeof(*s));
        if (!s) abort();
        pthread_mutex_init(&s->lock, NULL);
        dbus_bool_t (*add)(DBusConnection *, DBusHandleMessageFunction, void *, DBusFreeFunction);
        *(void **)(&add) = dlsym(RTLD_NEXT, "dbus_connection_add_filter");
        if (!add || !add(c, filter, s, NULL) ||
            !dbus_connection_set_data(c, slot, s, destroy)) abort();
        /* Drop stale IDs if the notification daemon restarts. */
        dbus_bus_add_match(c, "type='signal',sender='org.freedesktop.DBus',"
            "interface='org.freedesktop.DBus',member='NameOwnerChanged',"
            "arg0='org.freedesktop.Notifications'", NULL);
    }
    pthread_mutex_unlock(&init_lock);
    return s;
}
dbus_bool_t dbus_connection_add_filter(DBusConnection *c,
    DBusHandleMessageFunction fn, void *data, DBusFreeFunction free_fn)
{
    state_for(c);
    dbus_bool_t (*real)(DBusConnection *, DBusHandleMessageFunction, void *, DBusFreeFunction);
    *(void **)(&real) = dlsym(RTLD_NEXT, "dbus_connection_add_filter");
    return real(c, fn, data, free_fn);
}
dbus_bool_t dbus_connection_send_with_reply(DBusConnection *c, DBusMessage *m,
    DBusPendingCall **pending, int timeout)
{
    dbus_bool_t (*real)(DBusConnection *, DBusMessage *, DBusPendingCall **, int);
    *(void **)(&real) = dlsym(RTLD_NEXT, "dbus_connection_send_with_reply");
    if (!notify(m)) return real(c, m, pending, timeout);
    state_for(c);
    dbus_bool_t ok = real(c, m, pending, timeout);
    if (ok && pending && *pending) {
        if (!dbus_pending_call_set_data(*pending, pending_slot,
                dbus_connection_ref(c), (DBusFreeFunction)dbus_connection_unref)) abort();
    }
    return ok;
}
DBusMessage *dbus_pending_call_steal_reply(DBusPendingCall *pending)
{
    /* libdbus delivers pending replies before message filters. Qt takes the
     * reply in its pending-call callback, before dispatching later signals. */
    DBusMessage *(*real)(DBusPendingCall *);
    *(void **)(&real) = dlsym(RTLD_NEXT, "dbus_pending_call_steal_reply");
    DBusMessage *reply = real(pending);
    pthread_once(&once, allocate_slot);
    DBusConnection *c = dbus_pending_call_get_data(pending, pending_slot);
    if (c) {
        struct state *s = state_for(c);
        pthread_mutex_lock(&s->lock);
        remember(s, reply);
        pthread_mutex_unlock(&s->lock);
    }
    return reply;
}
DBusMessage *dbus_connection_send_with_reply_and_block(DBusConnection *c,
    DBusMessage *m, int timeout, DBusError *error)
{
    DBusMessage *(*real)(DBusConnection *, DBusMessage *, int, DBusError *);
    *(void **)(&real) = dlsym(RTLD_NEXT, "dbus_connection_send_with_reply_and_block");
    DBusMessage *reply = real(c, m, timeout, error);
    if (notify(m)) {
        struct state *s = state_for(c);
        pthread_mutex_lock(&s->lock);
        remember(s, reply);
        pthread_mutex_unlock(&s->lock);
    }
    return reply;
}
