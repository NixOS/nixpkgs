{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "eina-${version}";
  version = "1.2.0-alpha";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1vchzb34hd9z8ghh75ch7sdf90gmzzpxryk3yq8hjcdxd0zjx9yj";
  };
  meta = {
    description = "Enlightenment's core data structure library";
    longDescription = ''
      Enlightenment's Eina is a core data structure and common utility
      library.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.lgpl21;
  };
}
