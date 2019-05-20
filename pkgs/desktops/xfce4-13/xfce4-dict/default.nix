{ mkXfceDerivation, automakeAddFlags, gtk3, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.2";

  sha256 = "1zbb0k0984ny7wy4gbk6ymkh87rbfakpim54yq4r3h5ymslx7iv7";

  patches = [ ./configure-gio.patch ];

  nativeBuildInputs = [ automakeAddFlags ];

  postPatch = ''
    automakeAddFlags lib/Makefile.am libdict_la_CFLAGS GIO_CFLAGS
  '';

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel ];
}
