{ stdenv, fetchurl, pkgconfig, pure }:

stdenv.mkDerivation rec {
  baseName = "mpfr";
  version = "0.5";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "39d2255c2c0c2d60ce727be178b5e5a06f7c92eb365976c49c4a34b1edc576e7";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "This module makes the MPFR multiprecision floats available in Pure";
    homepage = http://puredocs.bitbucket.org/pure-mpfr.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
