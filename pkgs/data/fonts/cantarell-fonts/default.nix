{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  major = "0.0";
  minor = "24";
  name = "cantarell-fonts-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/cantarell-fonts/${major}/${name}.tar.xz";
    sha256 = "0r4jnc2x9yncf40lixjb1pqgpq8rzbi2fz33pshlqzjgx2d69bcw";
  };

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.ofl;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
