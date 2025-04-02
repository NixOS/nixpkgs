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
    strcpy(buf, DRV_DIR);
    strcat(buf, pathname + 4);
    return fopen_real(buf, mode);
  }

  return fopen_real(pathname, mode);
}

DIR *opendir(const char *name) {
  DIR *(*opendir_real)(const char *name) = dlsym(RTLD_NEXT, "opendir");

  if (strncmp(name, "/usr/", 5) == 0) {
    char buf[1024];
    strcpy(buf, DRV_DIR);
    strcat(buf, name + 4);
    return opendir_real(buf);
  }

  return opendir_real(name);
}
