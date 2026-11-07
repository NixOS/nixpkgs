/* Symlink GUI client paths to the daemon socket:
 *   /run/tetrd-<hex>.sock → /run/tetrd/run/tetrd.sock
 */

#include <errno.h>
#include <glob.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

static const char *const SERVICE_SOCK = "/run/tetrd/run/tetrd.sock";
static const char PREFIX[] = "/run/tetrd-";
static const char SUFFIX[] = ".sock";
/* Bound so a world-executable cap wrapper cannot flood /run with long names. */
static const size_t HEX_MIN = 8;
static const size_t HEX_MAX = 64;

static int path_allowed(const char *path) {
    size_t len, hex_lo, hex_hi, hex_len, i;

    if (strncmp(path, PREFIX, sizeof(PREFIX) - 1) != 0)
        return 0;

    len = strlen(path);
    hex_lo = sizeof(PREFIX) - 1;
    if (len <= hex_lo + sizeof(SUFFIX) - 1)
        return 0;

    hex_hi = len - (sizeof(SUFFIX) - 1);
    if (strcmp(path + hex_hi, SUFFIX) != 0)
        return 0;

    hex_len = hex_hi - hex_lo;
    if (hex_len < HEX_MIN || hex_len > HEX_MAX)
        return 0;

    /* App logs lowercase hex only. */
    for (i = hex_lo; i < hex_hi; i++) {
        char c = path[i];
        if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')))
            return 0;
    }
    return 1;
}

static void cleanup_old_sockets(void) {
    glob_t gl = {0};

    if (glob("/run/tetrd-*.sock", 0, NULL, &gl) != 0)
        return;

    for (size_t i = 0; i < gl.gl_pathc; i++) {
        if (!path_allowed(gl.gl_pathv[i]))
            continue;
        if (unlink(gl.gl_pathv[i]) != 0 && errno != ENOENT)
            fprintf(stderr, "tetrd-lnsock: warning: could not remove %s: %s\n",
                    gl.gl_pathv[i], strerror(errno));
    }
    globfree(&gl);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: tetrd-lnsock /run/tetrd-<hash>.sock | --cleanup\n");
        return 1;
    }

    if (strcmp(argv[1], "--cleanup") == 0) {
        cleanup_old_sockets();
        return 0;
    }

    if (!path_allowed(argv[1])) {
        fprintf(stderr, "tetrd-lnsock: refusing invalid target: %s\n", argv[1]);
        return 1;
    }

    cleanup_old_sockets();

    if (unlink(argv[1]) != 0 && errno != ENOENT) {
        perror("tetrd-lnsock: unlink");
        return 1;
    }

    if (symlink(SERVICE_SOCK, argv[1]) != 0) {
        perror("tetrd-lnsock: symlink");
        return 1;
    }

    return 0;
}
