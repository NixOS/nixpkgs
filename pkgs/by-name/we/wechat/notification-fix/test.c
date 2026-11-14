#include <dbus/dbus.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

#define SERVICE "org.freedesktop.Notifications"
#define PATH "/org/freedesktop/Notifications"
static unsigned seen;
static DBusHandlerResult observe(DBusConnection *c, DBusMessage *m, void *data)
{
    (void)c; (void)data;
    if (dbus_message_has_interface(m, SERVICE) &&
        dbus_message_get_type(m) == DBUS_MESSAGE_TYPE_SIGNAL) seen++;
    return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
}
static DBusMessage *call(const char *member)
{
    DBusMessage *m = dbus_message_new_method_call(SERVICE, PATH, SERVICE, member);
    assert(m);
    return m;
}
static void service(int ready)
{
    DBusConnection *c = dbus_bus_get_private(DBUS_BUS_SESSION, NULL);
    assert(c);
    assert(dbus_bus_request_name(c, SERVICE, 0, NULL) == DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER);
    assert(write(ready, "!", 1) == 1);
    close(ready);
    for (;;) {
        dbus_connection_read_write(c, 100);
        DBusMessage *m = dbus_connection_pop_message(c);
        if (!m) continue;
        if (dbus_message_get_type(m) == DBUS_MESSAGE_TYPE_METHOD_CALL) {
            DBusMessage *reply = dbus_message_new_method_return(m);
            if (dbus_message_has_member(m, "Notify")) {
                dbus_uint32_t id = 42;
                dbus_message_append_args(reply, DBUS_TYPE_UINT32, &id, DBUS_TYPE_INVALID);
            } else if (dbus_message_has_member(m, "Restart")) {
                assert(dbus_bus_release_name(c, SERVICE, NULL) == DBUS_RELEASE_NAME_REPLY_RELEASED);
                assert(dbus_bus_request_name(c, SERVICE, 0, NULL) == DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER);
            } else if (dbus_message_has_member(m, "Emit")) {
                dbus_uint32_t id;
                const char *member;
                assert(dbus_message_get_args(m, NULL, DBUS_TYPE_UINT32, &id,
                    DBUS_TYPE_STRING, &member, DBUS_TYPE_INVALID));
                DBusMessage *s = dbus_message_new_signal(PATH, SERVICE, member);
                dbus_message_append_args(s, DBUS_TYPE_UINT32, &id, DBUS_TYPE_INVALID);
                if (!strcmp(member, "NotificationClosed")) {
                    dbus_uint32_t reason = 2;
                    dbus_message_append_args(s, DBUS_TYPE_UINT32, &reason, DBUS_TYPE_INVALID);
                } else {
                    const char *action = "default";
                    dbus_message_append_args(s, DBUS_TYPE_STRING, &action, DBUS_TYPE_INVALID);
                }
                dbus_connection_send(c, s, NULL);
                dbus_message_unref(s);
            }
            dbus_connection_send(c, reply, NULL);
            dbus_connection_flush(c);
            dbus_message_unref(reply);
        }
        dbus_message_unref(m);
    }
}
static void emit(DBusConnection *c, dbus_uint32_t id, const char *member, unsigned expected)
{
    DBusMessage *m = call("Emit");
    dbus_message_append_args(m, DBUS_TYPE_UINT32, &id, DBUS_TYPE_STRING, &member, DBUS_TYPE_INVALID);
    DBusMessage *reply = dbus_connection_send_with_reply_and_block(c, m, 2000, NULL);
    assert(reply);
    dbus_message_unref(reply);
    dbus_message_unref(m);
    /* Emit sends the signal before its reply, so it is already queued. */
    while (dbus_connection_get_dispatch_status(c) == DBUS_DISPATCH_DATA_REMAINS)
        dbus_connection_dispatch(c);
    if (seen != expected)
        fprintf(stderr, "%s(%u): saw %u signals, expected %u\n", member, id, seen, expected);
    assert(seen == expected);
}
int main(void)
{
    int ready[2];
    assert(pipe(ready) == 0);
    pid_t child = fork();
    assert(child >= 0);
    if (!child) { close(ready[0]); service(ready[1]); return 0; }
    close(ready[1]);
    char byte;
    assert(read(ready[0], &byte, 1) == 1);
    close(ready[0]);
    DBusConnection *c = dbus_bus_get_private(DBUS_BUS_SESSION, NULL);
    assert(c);
    assert(dbus_connection_add_filter(c, observe, NULL, NULL));
    dbus_bus_add_match(c, "type='signal',interface='org.freedesktop.Notifications'", NULL);
    emit(c, 7, "ActionInvoked", 0); /* Even before WeChat's first notification. */
    DBusMessage *m = call("Notify");
    DBusMessage *reply = dbus_connection_send_with_reply_and_block(c, m, 2000, NULL);
    assert(reply);
    dbus_message_unref(reply);
    dbus_message_unref(m);
    emit(c, 7, "ActionInvoked", 0);
    emit(c, 7, "ActivationToken", 0);
    emit(c, 42, "ActivationToken", 1);
    emit(c, 42, "ActionInvoked", 2);
    emit(c, 7, "NotificationClosed", 2);
    emit(c, 42, "NotificationClosed", 3);
    emit(c, 42, "ActionInvoked", 3); /* Closed/reused IDs are no longer ours. */
    m = call("Notify");
    DBusPendingCall *pending = NULL;
    assert(dbus_connection_send_with_reply(c, m, &pending, 2000) && pending);
    dbus_connection_flush(c);
    /* Exercise dispatch of asynchronous replies, as used by Qt. */
    while (!dbus_pending_call_get_completed(pending))
        dbus_connection_read_write_dispatch(c, 2000);
    reply = dbus_pending_call_steal_reply(pending);
    assert(reply);
    dbus_message_unref(reply);
    dbus_pending_call_unref(pending);
    dbus_message_unref(m);
    emit(c, 42, "ActionInvoked", 4);
    DBusConnection *other = dbus_bus_get_private(DBUS_BUS_SESSION, NULL);
    assert(other);
    assert(dbus_connection_add_filter(other, observe, NULL, NULL));
    dbus_bus_add_match(other, "type='signal',interface='org.freedesktop.Notifications'", NULL);
    emit(other, 42, "ActionInvoked", 4); /* IDs do not cross connections. */
    dbus_connection_close(other);
    dbus_connection_unref(other);
    /* The broadcast to 'other' is also queued on c, where ID 42 is owned. */
    emit(c, 7, "Unrelated", 6); /* Other signals are unaffected. */
    m = call("Restart");
    reply = dbus_connection_send_with_reply_and_block(c, m, 2000, NULL);
    assert(reply);
    dbus_message_unref(reply);
    dbus_message_unref(m);
    emit(c, 42, "ActionInvoked", 6); /* A new daemon may reuse old IDs. */
    dbus_connection_close(c);
    dbus_connection_unref(c);
    kill(child, SIGTERM);
    waitpid(child, NULL, 0);
    puts("notification action isolation: OK");
    return 0;
}
