{ stdenv, fetchurl, pkgconfig, pure, liblo }:

stdenv.mkDerivation rec {
  baseName = "liblo";
  version = "0.9";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "c2ba4d6f94489acf8a8fac73982ae03d5ad4113146eb1f7d6558a956c57cb8ee";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure liblo ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A quick and dirty Pure wrapper for the liblo library, which implements Berkeley’s Open Sound Control (OSC) protocol";
    homepage = http://puredocs.bitbucket.org/pure-liblo.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
