{ mkXfceDerivation, automakeAddFlags, gtk3, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.3";

  sha256 = "0p7k2ffknr23hh3j17dhh5q8adn736p2piwx0sg8f5dvvhhc5whz";

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
