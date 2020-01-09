{ stdenv, fetchurl, pkgconfig, pure }:

stdenv.mkDerivation rec {
  baseName = "stllib";
  version = "0.6";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-stllib-${version}.tar.gz";
    sha256 = "1d550764fc2f8ba6ddbd1fbd3da2d6965b69e2c992747265d9ebe4f16aa5e455";
  };

  postPatch = ''
    for f in pure-stlmap/{stlmap.cpp,stlmmap.cpp,stlhmap.cpp}; do
      sed -i '1i\#include <cstddef>' $f
    done
  '';

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "An “umbrella” package that contains a pair of Pure addons, pure-stlvec and pure-stlmap";
    homepage = http://puredocs.bitbucket.org/pure-stllib.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
