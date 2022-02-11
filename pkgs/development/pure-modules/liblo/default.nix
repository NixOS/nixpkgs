{ lib, stdenv, fetchurl, pkg-config, pure, liblo }:

stdenv.mkDerivation rec {
  pname = "pure-liblo";
  version = "0.9";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-liblo-${version}.tar.gz";
    sha256 = "c2ba4d6f94489acf8a8fac73982ae03d5ad4113146eb1f7d6558a956c57cb8ee";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure liblo ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A quick and dirty Pure wrapper for the liblo library, which implements Berkeley’s Open Sound Control (OSC) protocol";
    homepage = "http://puredocs.bitbucket.org/pure-liblo.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
