args: with args;

rec {

  glib = (import ./glib) args;

  atk = (import ./atk) (args // { inherit glib; });

  pango = (import ./pango) (args // { inherit glib; });

  gtk = (import ./gtk+) (args // { inherit glib atk pango; } );
}
