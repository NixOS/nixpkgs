#! /bin/sh
choice="$1";
<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        ;;
esac
