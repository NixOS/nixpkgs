#! /bin/sh
choice="$1";
[ "$#" = "0" ] || shift;
case "$choice" in
    encode | create | write | CommandLineEncoder)
        @out@/bin/zxing-cmdline-encoder "$@";
        ;;
    decode | read | run | CommandLineRunner)
        @out@/bin/zxing-cmdline-runner "$@";
        ;;
    gui | GUIRunner)
        @out@/bin/zxing-gui-runner "$@";
        ;;
    help | usage | --help | --usage | -h)
        @out@/bin/zxing read --help;
        @out@/bin/zxing write --help;
        ;;
    *)
        @out@/bin/zxing read "$choice" "$@";
        ;;
esac
