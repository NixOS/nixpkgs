#ifdef __APPLE__
#include <pwd.h>
#include <unistd.h>
#include <string.h>

#ifndef L_cuserid
#define L_cuserid 256
#endif

static inline char *cuserid(char *s) {
    const struct passwd *pw = getpwuid(geteuid());
    const char *name = (pw && pw->pw_name) ? pw->pw_name : "unknown";

    static char buf[L_cuserid];
    char *out = s ? s : buf;

    strncpy(out, name, L_cuserid - 1);
    out[L_cuserid - 1] = '\0';
    return out;
}
#endif /* __APPLE__ */
