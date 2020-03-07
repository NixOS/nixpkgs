{ stdenv, fetchurl, pkgconfig, pure }:

stdenv.mkDerivation rec {
  baseName = "stldict";
  version = "0.8";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "5b894ae6dc574c7022258e2732bea649c82c959ec4d0be13fb5a3e8ba8488f28";
  };

  postPatch = ''
    for f in hashdict.cc orddict.cc; do
      sed -i '1i\#include <stddef.h>' $f
    done
  '';

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A Pure interface to the C++ dictionary containers map and unordered_map";
    homepage = http://puredocs.bitbucket.org/pure-stldict.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
