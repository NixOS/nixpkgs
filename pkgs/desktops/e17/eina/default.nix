{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "eina-${version}";
  version = "1.1.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "0h2vmvr7bmnb19n124bjvi2rddv7vm15pv19lrpc7av3idk7ic4j";
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
