{ pngSupport ? true
, stdenv, fetchurl, x11, libpng ? null}:

assert x11 != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "zvbi-0.2.8";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/zvbi-0.2.8.tar.bz2;
    md5 = "8701d3e4387cd896ff8b68831b57d814";
  };
  buildInputs = [x11 (if pngSupport then libpng else null)];
  inherit pngSupport;
}
