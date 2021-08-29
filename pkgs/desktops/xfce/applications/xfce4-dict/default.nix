{ mkXfceDerivation, automakeAddFlags, gtk3, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.4";

  sha256 = "0gm5gwqxhnv3qz9ggf8dj1sq5s72xcliidkyip9l91msx03hfjah";

  patches = [ ./configure-gio.patch ];

  nativeBuildInputs = [ automakeAddFlags ];

  postPatch = ''
    automakeAddFlags lib/Makefile.am libdict_la_CFLAGS GIO_CFLAGS
  '';

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel ];

  meta = {
    description = "A Dictionary Client for the Xfce desktop environment";
  };
}
