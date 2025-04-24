#define _GNU_SOURCE
#include <dirent.h>
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>

FILE *fopen(const char *restrict pathname, const char *restrict mode) {
  FILE *(*fopen_real)(const char *restrict pathname,
                      const char *restrict mode) = dlsym(RTLD_NEXT, "fopen");

  if (strncmp(pathname, "/usr/", 5) == 0) {
    char buf[1024];
    if (snprintf(buf, sizeof(buf), "%s%s", DRV_DIR, pathname + 4) >= sizeof(buf)) {
      // Path too long
      return NULL;
    }
    return fopen_real(buf, mode);
  }

  return fopen_real(pathname, mode);
}

DIR *opendir(const char *name) {
  DIR *(*opendir_real)(const char *name) = dlsym(RTLD_NEXT, "opendir");

  if (strncmp(name, "/usr/", 5) == 0) {
    char buf[1024];
    if (snprintf(buf, sizeof(buf), "%s%s", DRV_DIR, name + 4) >= sizeof(buf)) {
      // Path too long
      return NULL;
    }
    return opendir_real(buf);
  }

  return opendir_real(name);
}
