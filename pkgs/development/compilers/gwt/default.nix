{stdenv, fetchurl, glib, gtk, pango, atk, libX11, libXt, libstdcpp5, jdk}:

stdenv.mkDerivation {
  name = "gwt-linux-1.7.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://google-web-toolkit.googlecode.com/files/gwt-linux-1.7.1.tar.bz2;
    sha256 = "0lgirr9lr0qsfvw61hqzracdllqklb4qkzbk5x3lc4r64mms5b3g";
  };

  inherit glib gtk pango atk libX11 libXt libstdcpp5 jdk;
  buildInputs = [glib gtk pango atk libX11 libXt libstdcpp5];
}
