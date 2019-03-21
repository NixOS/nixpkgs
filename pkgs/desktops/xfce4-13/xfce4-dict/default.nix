{ mkXfceDerivation, automakeAddFlags, gtk3, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.1";

  sha256 = "0kxirzqmpp7qlr8220i8kipz4bgzkam7h1lpx7yzld5xf7wdzvaf";

  patches = [ ./configure-gio.patch ];

  nativeBuildInputs = [ automakeAddFlags ];

  postPatch = ''
    automakeAddFlags lib/Makefile.am libdict_la_CFLAGS GIO_CFLAGS
  '';

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel ];
}
