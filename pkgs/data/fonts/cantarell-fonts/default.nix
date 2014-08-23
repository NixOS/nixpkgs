{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "cantarell-fonts-0.0.15";

  src = fetchurl {
    url = mirror://gnome/sources/cantarell-fonts/0.0/cantarell-fonts-0.0.15.tar.xz;
    sha256 = "0zmwzzfjrlpkdjb475ann11m53a2idm76ydd2rw1hjmdr74dq72j";
  };

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
