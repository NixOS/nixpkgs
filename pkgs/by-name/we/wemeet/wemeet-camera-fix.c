/*
 * LD_PRELOAD shim for WeMeet's camera preview on Wayland.
 *
 * WeMeet's libxcast.so uses EGL to render the local camera preview. It links
 * against libEGL and libX11, and later passes X11 native windows to EGL. In a
 * Wayland session, Mesa can choose the Wayland EGL platform for
 * eglGetDisplay(NULL), which makes libxcast.so hand an X11 XID to the Wayland
 * platform path when creating its window surface. The camera still opens and
 * remote participants can see it, but the local preview fails to render or may
 * crash.
 *
 * Only for calls originating in libxcast.so, force EGL display creation through
 * the X11 platform. Qt/QtWebEngine and other callers continue to use their
 * normal EGL path.
 */

#define _GNU_SOURCE
#include <dlfcn.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <X11/Xlib.h>

#ifndef EGL_PLATFORM_X11_KHR
#define EGL_PLATFORM_X11_KHR 0x31D5
#endif

typedef EGLDisplay (*pfn_eglGetDisplay)(EGLNativeDisplayType);
typedef EGLDisplay (*pfn_eglGetPlatformDisplay)(EGLenum, void *, const EGLAttrib *);
typedef EGLDisplay (*pfn_eglGetPlatformDisplayEXT)(EGLenum, void *, const EGLint *);

static pfn_eglGetDisplay real_eglGetDisplay;
static pfn_eglGetPlatformDisplay real_eglGetPlatformDisplay;
static pfn_eglGetPlatformDisplayEXT real_eglGetPlatformDisplayEXT;

static EGLDisplay x11_egl_display = EGL_NO_DISPLAY;
static Display *x_display;
static pthread_once_t once_resolve = PTHREAD_ONCE_INIT;
static pthread_once_t once_x11 = PTHREAD_ONCE_INIT;

static int debug_enabled(void)
{
    static int value = -1;
    if (value < 0) {
        value = getenv("WEMEET_CAMERA_FIX_DEBUG") != NULL;
    }
    return value;
}

#define LOG(...)                                                               \
    do {                                                                       \
        if (debug_enabled()) {                                                 \
            fprintf(stderr, "[wemeet-camera-fix] " __VA_ARGS__);               \
        }                                                                      \
    } while (0)

static void resolve_real_symbols(void)
{
    real_eglGetDisplay = (pfn_eglGetDisplay)dlsym(RTLD_NEXT, "eglGetDisplay");
    real_eglGetPlatformDisplay =
        (pfn_eglGetPlatformDisplay)dlsym(RTLD_NEXT, "eglGetPlatformDisplay");
    real_eglGetPlatformDisplayEXT =
        (pfn_eglGetPlatformDisplayEXT)dlsym(RTLD_NEXT, "eglGetPlatformDisplayEXT");
}

static void init_x11_egl_display(void)
{
    pthread_once(&once_resolve, resolve_real_symbols);

    x_display = XOpenDisplay(NULL);
    if (!x_display) {
        fprintf(stderr, "[wemeet-camera-fix] XOpenDisplay(NULL) failed; DISPLAY=%s\n",
                getenv("DISPLAY") ? getenv("DISPLAY") : "(unset)");
        return;
    }

    if (real_eglGetPlatformDisplay) {
        x11_egl_display =
            real_eglGetPlatformDisplay(EGL_PLATFORM_X11_KHR, x_display, NULL);
    } else if (real_eglGetPlatformDisplayEXT) {
        x11_egl_display =
            real_eglGetPlatformDisplayEXT(EGL_PLATFORM_X11_KHR, x_display, NULL);
    } else if (real_eglGetDisplay) {
        x11_egl_display = real_eglGetDisplay((EGLNativeDisplayType)x_display);
    }

    LOG("initialized X11 EGLDisplay=%p for X Display*=%p\n",
        (void *)x11_egl_display, (void *)x_display);
}

static int caller_is_xcast(void *caller)
{
    Dl_info info;

    if (!caller) {
        return 0;
    }
    memset(&info, 0, sizeof(info));
    if (!dladdr(caller, &info) || !info.dli_fname) {
        return 0;
    }
    return strstr(info.dli_fname, "libxcast.so") != NULL;
}

EGLDisplay eglGetDisplay(EGLNativeDisplayType display_id)
{
    pthread_once(&once_resolve, resolve_real_symbols);

    if (caller_is_xcast(__builtin_return_address(0))) {
        pthread_once(&once_x11, init_x11_egl_display);
        LOG("eglGetDisplay from libxcast.so -> %p\n", (void *)x11_egl_display);
        return x11_egl_display;
    }

    return real_eglGetDisplay ? real_eglGetDisplay(display_id) : EGL_NO_DISPLAY;
}

EGLDisplay eglGetPlatformDisplay(EGLenum platform, void *native_display,
                                 const EGLAttrib *attrib_list)
{
    pthread_once(&once_resolve, resolve_real_symbols);

    if (caller_is_xcast(__builtin_return_address(0))) {
        pthread_once(&once_x11, init_x11_egl_display);
        LOG("eglGetPlatformDisplay from libxcast.so -> %p\n",
            (void *)x11_egl_display);
        return x11_egl_display;
    }

    return real_eglGetPlatformDisplay
               ? real_eglGetPlatformDisplay(platform, native_display, attrib_list)
               : EGL_NO_DISPLAY;
}

EGLDisplay eglGetPlatformDisplayEXT(EGLenum platform, void *native_display,
                                    const EGLint *attrib_list)
{
    pthread_once(&once_resolve, resolve_real_symbols);

    if (caller_is_xcast(__builtin_return_address(0))) {
        pthread_once(&once_x11, init_x11_egl_display);
        LOG("eglGetPlatformDisplayEXT from libxcast.so -> %p\n",
            (void *)x11_egl_display);
        return x11_egl_display;
    }

    return real_eglGetPlatformDisplayEXT
               ? real_eglGetPlatformDisplayEXT(platform, native_display, attrib_list)
               : EGL_NO_DISPLAY;
}
