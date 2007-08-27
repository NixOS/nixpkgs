{ pngSupport ? true
, stdenv, fetchurl, x11, libpng ? null}:

assert x11 != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "zvbi-0.2.12";
  src = fetchurl {
    url = mirror://sourceforge/zapping/zvbi-0.2.22.tar.bz2;
    md5 = "a01cbe39a48579ba92582ff75a5e37c2";
  };
  buildInputs = [x11 (if pngSupport then libpng else null)];
  inherit pngSupport;
}
