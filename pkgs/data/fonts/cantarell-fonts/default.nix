{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "cantarell-fonts-0.0.17";

  src = fetchurl {
    url = mirror://gnome/sources/cantarell-fonts/0.0/cantarell-fonts-0.0.17.tar.xz;
    sha256 = "0kx05fw1i11zcqx5yv9y9iprpl49k51sibz86bc58a50n1w6gcwn";
  };

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.ofl;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
