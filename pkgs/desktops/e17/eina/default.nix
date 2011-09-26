{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "eina-${version}";
  version = "1.0.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "1v2z1l6nqr7hnp5gki3972kprlvylpalp5wq9xdppm250z91kaas";
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
