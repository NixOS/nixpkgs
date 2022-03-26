{ lib, stdenv, fetchurl, pkg-config, pure }:

stdenv.mkDerivation rec {
  pname = "pure-stldict";
  version = "0.8";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-stldict-${version}.tar.gz";
    sha256 = "5b894ae6dc574c7022258e2732bea649c82c959ec4d0be13fb5a3e8ba8488f28";
  };

  postPatch = ''
    for f in hashdict.cc orddict.cc; do
      sed -i '1i\#include <stddef.h>' $f
    done
  '';

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A Pure interface to the C++ dictionary containers map and unordered_map";
    homepage = "http://puredocs.bitbucket.org/pure-stldict.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
