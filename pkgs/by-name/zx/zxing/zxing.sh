#! /bin/sh
choice="$1";
shift
case "$choice" in
    encode | create | write | CommandLineEncoder)
        zxing-cmdline-encoder "$@";
        ;;
    decode | read | run | CommandLineRunner)
        zxing-cmdline-runner "$@";
        ;;
    help | usage | --help | --usage | -h)
        zxing read;
        zxing write;
        ;;
    *)
        zxing read "$choice" "$@"
        ;;
esac
