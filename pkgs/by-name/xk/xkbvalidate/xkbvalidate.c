#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <xkbcommon/xkbcommon.h>

static char **log_buffer = NULL;
static int log_buffer_size = 0;
static bool log_alloc_success = true;

static void add_log(struct xkb_context *ctx, enum xkb_log_level level,
                    const char *fmt, va_list args)
{
    size_t buflen;
    va_list tmpargs;

    log_buffer_size++;

    if (log_buffer == NULL)
        log_buffer = malloc(sizeof(char *));
    else
        log_buffer = realloc(log_buffer, sizeof(char *) * log_buffer_size);

    if (log_buffer == NULL) {
        perror("buffer alloc");
        log_alloc_success = false;
        log_buffer_size--;
        return;
    }

    /* Unfortunately, vasprintf() is a GNU extension and thus not very
     * portable, so let's first get the required buffer size using a dummy
     * vsnprintf and afterwards allocate the returned amount of bytes.
     *
     * We also need to make a copy of the args, because the value of the args
     * will be indeterminate after the return.
     */
    va_copy(tmpargs, args);
    buflen = vsnprintf(NULL, 0, fmt, tmpargs);
    va_end(tmpargs);

    log_buffer[log_buffer_size - 1] = malloc(++buflen);

    if (vsnprintf(log_buffer[log_buffer_size - 1], buflen, fmt, args) == -1) {
        perror("log line alloc");
        log_alloc_success = false;
    }
    va_end(args);
}

static void print_logs(void)
{
    for (int i = 0; i < log_buffer_size; ++i)
        fprintf(stderr, "    %s", log_buffer[i]);
}

static void free_logs(void)
{
    if (log_buffer == NULL)
        return;
    for (int i = 0; i < log_buffer_size; ++i)
        free(log_buffer[i]);
    free(log_buffer);
    log_buffer = NULL;
    log_buffer_size = 0;
}

static bool try_keymap(struct xkb_context *ctx, struct xkb_rule_names *rdef)
{
    struct xkb_keymap *keymap;
    bool result = true;

    if ((keymap = xkb_keymap_new_from_names(ctx, rdef, 0)) == NULL)
        result = false;
    else
        xkb_keymap_unref(keymap);

    return result;
}

static void print_error(const char *name, const char *value,
                        const char *nixos_option)
{
    fprintf(stderr, "\nThe value `%s' for keyboard %s is invalid.\n\n"
                    "Please check the definition in `services.xserver.%s'.\n",
            value, name, nixos_option);
    fputs("\nDetailed XKB compiler errors:\n\n", stderr);
    print_logs();
    putc('\n', stderr);
}

#define TRY_KEYMAP(name, value, nixos_option) \
    *rdef = (struct xkb_rule_names) {0}; \
    free_logs(); \
    rdef->name = value; \
    result = try_keymap(ctx, rdef); \
    if (!log_alloc_success) \
        goto out; \
    if (!result) { \
        print_error(#name, value, nixos_option); \
        exit_code = EXIT_FAILURE; \
        goto out; \
    }

int main(int argc, char **argv)
{
    int exit_code = EXIT_SUCCESS;
    bool result;
    struct xkb_context *ctx;
    struct xkb_rule_names *rdef;

    if (argc != 5) {
        fprintf(stderr, "Usage: %s model layout variant options\n", argv[0]);
        return EXIT_FAILURE;
    }

    ctx = xkb_context_new(XKB_CONTEXT_NO_ENVIRONMENT_NAMES);
    xkb_context_set_log_fn(ctx, add_log);

    rdef = malloc(sizeof(struct xkb_rule_names));

    TRY_KEYMAP(model,   argv[1], "xkb.model");
    TRY_KEYMAP(layout,  argv[2], "xkb.layout");
    TRY_KEYMAP(variant, argv[3], "xkb.variant");
    TRY_KEYMAP(options, argv[4], "xkb.options");

    free_logs();
    rdef->model = argv[1];
    rdef->layout = argv[2];
    rdef->variant = argv[3];
    rdef->options = argv[4];

    result = try_keymap(ctx, rdef);
    if (!log_alloc_success)
        goto out;

    if (!result) {
        fputs("The XKB keyboard definition failed to compile:\n", stderr);
        print_logs();
        exit_code = EXIT_FAILURE;
    }

out:
    free_logs();
    free(rdef);
    xkb_context_unref(ctx);
    return exit_code;
}
