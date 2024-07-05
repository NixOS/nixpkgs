/*
  This and the shell builder was originally written by
  https://github.com/tpoechtrager but I had to modify both so that
  they played nicely and were reproducible with nixpkgs. Much thanks
  to MixRank for letting me work on this.
  Edgar Aroutiounian <edgar.factorial@gmail.com>
 */

#ifndef TARGET_CPU
#define TARGET_CPU "armv7"
#endif

#ifndef OS_VER_MIN
#define OS_VER_MIN "4.2"
#endif

#ifndef NIX_APPLE_HDRS
#define NIX_APPLE_HDRS ""
#endif

#ifndef NIX_APPLE_FRAMEWORKS
#define NIX_APPLE_FRAMEWORKS ""
#endif

#ifndef NIX_APPLE_PRIV_FRAMEWORKS
#define NIX_APPLE_PRIV_FRAMEWORKS ""
#endif

#define _GNU_SOURCE

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stddef.h>
#include <unistd.h>
#include <limits.h>

#ifdef __APPLE__
#include <mach-o/dyld.h>
#endif

#if defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__DragonFly__)
#include <sys/sysctl.h>
#endif

#ifdef __OpenBSD__
#include <sys/types.h>
#include <sys/user.h>
#include <sys/stat.h>
#endif

char *get_executable_path(char *epath, size_t buflen)
{
  char *p;
#ifdef __APPLE__
  unsigned int l = buflen;
  if (_NSGetExecutablePath(epath, &l) != 0) return NULL;
#elif defined(__FreeBSD__) || defined(__DragonFly__)
  int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PATHNAME, -1 };
  size_t l = buflen;
  if (sysctl(mib, 4, epath, &l, NULL, 0) != 0) return NULL;
#elif defined(__OpenBSD__)
  int mib[4];
  char **argv;
  size_t len;
  size_t l;
  const char *comm;
  int ok = 0;
  mib[0] = CTL_KERN;
  mib[1] = KERN_PROC_ARGS;
  mib[2] = getpid();
  mib[3] = KERN_PROC_ARGV;
  if (sysctl(mib, 4, NULL, &len, NULL, 0) < 0)
    abort();
  if (!(argv = malloc(len)))
    abort();
  if (sysctl(mib, 4, argv, &len, NULL, 0) < 0)
    abort();
  comm = argv[0];
  if (*comm == '/' || *comm == '.') {
    char *rpath;
    if ((rpath = realpath(comm, NULL))) {
      strlcpy(epath, rpath, buflen);
      free(rpath);
      ok = 1;
    }
  } else {
    char *sp;
    char *xpath = strdup(getenv("PATH"));
    char *path = strtok_r(xpath, ":", &sp);
    struct stat st;
    if (!xpath)
      abort();
    while (path) {
      snprintf(epath, buflen, "%s/%s", path, comm);
      if (!stat(epath, &st) && (st.st_mode & S_IXUSR)) {
	ok = 1;
	break;
      }
      path = strtok_r(NULL, ":", &sp);
    }
    free(xpath);
  }
  free(argv);
  if (!ok) return NULL;
  l = strlen(epath);
#else
  ssize_t l = readlink("/proc/self/exe", epath, buflen);
#endif
  if (l <= 0) return NULL;
  epath[buflen - 1] = '\0';
  p = strrchr(epath, '/');
  if (p) *p = '\0';
  return epath;
}

char *get_filename(char *str)
{
  char *p = strrchr(str, '/');
  return p ? &p[1] : str;
}

void target_info(char *argv[], char **triple, char **compiler)
{
  char *p = get_filename(argv[0]);
  char *x = strrchr(p, '-');
  if (!x) abort();
  *compiler = &x[1];
  *x = '\0';
  *triple = p;
}

void env(char **p, const char *name, char *fallback)
{
  char *ev = getenv(name);
  if (ev) { *p = ev; return; }
  *p = fallback;
}

int main(int argc, char *argv[])
{
  char **args = alloca(sizeof(char*) * (argc + 17));
  int i, j;

  char execpath[PATH_MAX+1];
  char sdkpath[PATH_MAX+1];
  char codesign_allocate[64];
  char osvermin[64];

  char *compiler, *target, *sdk, *cpu, *osmin;

  target_info(argv, &target, &compiler);

  if (!get_executable_path(execpath, sizeof(execpath))) abort();
  snprintf(sdkpath, sizeof(sdkpath), "%s/../SDK", execpath);

  snprintf(codesign_allocate, sizeof(codesign_allocate),
	   "%s-codesign_allocate", target);

  setenv("CODESIGN_ALLOCATE", codesign_allocate, 1);
  setenv("IOS_FAKE_CODE_SIGN", "1", 1);

  env(&sdk, "IOS_SDK_SYSROOT", sdkpath);
  env(&cpu, "IOS_TARGET_CPU", TARGET_CPU);

  env(&osmin, "IPHONEOS_DEPLOYMENT_TARGET", OS_VER_MIN);
  unsetenv("IPHONEOS_DEPLOYMENT_TARGET");

  snprintf(osvermin, sizeof(osvermin), "-miphoneos-version-min=%s", osmin);

  for (i = 1; i < argc; ++i) {
    if (!strcmp(argv[i], "-arch")) {
      cpu = NULL;
      break;
    }
  }

  i = 0;

  args[i++] = compiler;
  args[i++] = "-target";
  args[i++] = target;
  args[i++] = "-isysroot";
  args[i++] = sdk;
  args[i++] = NIX_APPLE_HDRS;
  args[i++] = "-F";
  args[i++] = NIX_APPLE_FRAMEWORKS;
  args[i++] = "-F";
  args[i++] = NIX_APPLE_PRIV_FRAMEWORKS;

  if (cpu) {
    args[i++] = "-arch";
    args[i++] = cpu;
  }

  args[i++] = osvermin;
  args[i++] = "-mlinker-version=253.3";

  for (j = 1; j < argc; ++i, ++j) args[i] = argv[j];

  args[i] = NULL;

  setenv("COMPILER_PATH", execpath, 1);
  /* int k; */
  /* for (k = 0; k < i; k++) */
  /*   printf("Compiler option: %s\n", args[k]); */
  /* printf("End of Compiler args\n"); */
  execvp(compiler, args);

  fprintf(stderr, "cannot invoke compiler, this is a serious bug\n");
  return 1;
}
