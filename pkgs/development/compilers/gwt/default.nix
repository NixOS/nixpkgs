{stdenv, fetchurl, glib, gtk, pango, atk, libX11, libXt, libstdcpp5}:

stdenv.mkDerivation {
  name = "gwt-linux-1.4.61";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://google-web-toolkit.googlecode.com/files/gwt-linux-1.4.61.tar.bz2;
    md5 = "5aa5d630716817f7cf22dc2a36c0fcbd";
  };

  inherit glib gtk pango atk libX11 libXt libstdcpp5;
  buildInputs = [glib gtk pango atk libX11 libXt libstdcpp5];
}
