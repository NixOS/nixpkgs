args: with args;

# FIXME: Someone please upgrade the remaining libraries in `legacy'.
let legacy = {
     inherit ((import ../2.12) args) glibmm gtkmm;
    };
in

  rec {

    glib = (import ./glib) args;

    atk = (import ./atk) (args // { inherit glib; });

    pango = (import ./pango) (args // { inherit glib; });

    gtk = (import ./gtk+) (args // {
      inherit glib atk pango;
    });

  }

  //

  legacy
