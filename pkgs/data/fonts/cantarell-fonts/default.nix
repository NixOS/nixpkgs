{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "cantarell-fonts-0.0.16";

  src = fetchurl {
    url = mirror://gnome/sources/cantarell-fonts/0.0/cantarell-fonts-0.0.16.tar.xz;
    sha256 = "071g2l89gdjgqhapw9dbm1ch6hnzydhf7b38pi86fm91adaqggqm";
  };

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.ofl;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
