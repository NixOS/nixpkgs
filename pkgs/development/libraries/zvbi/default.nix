{ pngSupport ? true
, stdenv, fetchurl, x11, libpng ? null}:

assert x11 != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "zvbi-0.2.5";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/zvbi-0.2.5.tar.bz2;
    md5 = "06b370565246758813f6580797369518";
  };
  buildInputs = [x11 (if pngSupport then libpng else null)];
  inherit pngSupport;
}
