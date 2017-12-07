{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "fastjet-${version}";
  version = "3.3.0";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    sha256 = "03x75mmnlw2m0a7669k82rf9a7dgjwygf8wjbk8cdgnb82c5pnp9";
  };

  buildInputs = [ python2 ];

  configureFlags = [
    "--enable-allcxxplugins"
    "--enable-pyext"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "A software package for jet finding in pp and e+e− collisions";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = http://fastjet.fr/;
    platforms   = stdenv.lib.platforms.unix;
  };
}
