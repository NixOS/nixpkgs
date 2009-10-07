{stdenv, fetchurl, glib, gtk, pango, atk, libX11, libXt, libstdcpp5}:

stdenv.mkDerivation {
  name = "gwt-linux-1.5.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://google-web-toolkit.googlecode.com/files/gwt-linux-1.5.3.tar.bz2;
    sha1 = "5d7d3295cef4d0eb06a991138e9f538409146027";
  };

  inherit glib gtk pango atk libX11 libXt libstdcpp5;
  buildInputs = [glib gtk pango atk libX11 libXt libstdcpp5];
}
