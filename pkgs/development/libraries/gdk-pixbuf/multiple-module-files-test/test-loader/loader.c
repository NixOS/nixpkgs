#define GDK_PIXBUF_ENABLE_BACKEND
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <gdk-pixbuf/gdk-pixbuf-io.h>
#undef  GDK_PIXBUF_ENABLE_BACKEND


#ifndef PIXBUF_COLOR
#error PIXBUF_COLOR must be set to a hex color string.
#endif


G_MODULE_EXPORT void fill_vtable(GdkPixbufModule* module);

G_MODULE_EXPORT void fill_info(GdkPixbufFormat* info);


typedef struct {
    GdkPixbufModuleUpdatedFunc update_func;
    GdkPixbufModulePreparedFunc prepare_func;
    GdkPixbufModuleSizeFunc size_func;
    gpointer user_data;
} TestPixbufCtx;


static gpointer begin_load(
    GdkPixbufModuleSizeFunc size_func,
    GdkPixbufModulePreparedFunc prepare_func,
    GdkPixbufModuleUpdatedFunc update_func,
    gpointer user_data,
    GError** error
) {
    TestPixbufCtx* tpc;

    tpc = g_new0(TestPixbufCtx, 1);
    tpc->size_func = size_func;
    tpc->prepare_func = prepare_func;
    tpc->update_func = update_func;
    tpc->user_data = user_data;

    return tpc;
}


static char * xpm[] = {
    // width, height, #colors, #chars_per_pixel
    "1 1 1 1",
    // palette
    "a c " PIXBUF_COLOR,
    // image
    "a"
};

static gboolean stop_load(gpointer context, GError** error) {
    TestPixbufCtx* tpc = (TestPixbufCtx*) context;
    int width, height;
    int requested_width, requested_height;
    g_autoptr(GdkPixbuf) pixbuf;


    width = 1;
    height = 1;
    requested_width = width;
    requested_height = height;

    if (tpc->size_func) {
        (*tpc->size_func)(&requested_width, &requested_height, tpc->user_data);
    }

    pixbuf = gdk_pixbuf_new_from_xpm_data(xpm);

    if (tpc->prepare_func) {
        (*tpc->prepare_func)(pixbuf, NULL, tpc->user_data);
    }

    if (tpc->update_func != NULL) {
        (*tpc->update_func)(pixbuf, 0, 0, gdk_pixbuf_get_width(pixbuf), gdk_pixbuf_get_height(pixbuf), tpc->user_data);
    }

    g_clear_object(&pixbuf);
    g_free(tpc);

    return TRUE;
}


static gboolean load_increment(gpointer context, const guchar* buf, guint size, GError** error) {
    return TRUE;
}


void fill_vtable(GdkPixbufModule* module) {
    module->begin_load = begin_load;
    module->stop_load = stop_load;
    module->load_increment = load_increment;
}


void fill_info(GdkPixbufFormat* info) {
    static GdkPixbufModulePattern signature[] = {
        {"GIF8", NULL, 100},
        {NULL, NULL, 0}
    };

    static gchar* mime_types[] = {
        "image/gif",
        NULL
    };

    static gchar* extensions[] = {
        "gif",
        NULL
    };

    info->name = "test";
    info->signature = signature;
    info->domain = NULL;
    info->description = "Loader for testing priority of loaders";
    info->mime_types = mime_types;
    info->extensions = extensions;
    info->flags = GDK_PIXBUF_FORMAT_THREADSAFE;
    info->disabled = FALSE;
    info->license = "MIT";
}