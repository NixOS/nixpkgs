{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "eina-${version}";
  version = "1.7.10";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "06pqn17zknmxzdk5gw6df0gpbicnrdjl9g4vncw57k2wzf5icy33";
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
