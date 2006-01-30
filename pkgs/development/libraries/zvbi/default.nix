{ pngSupport ? true
, stdenv, fetchurl, x11, libpng ? null}:

assert x11 != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "zvbi-0.2.16";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/zvbi-0.2.16.tar.bz2;
    md5 = "6ed822ae5d0766129bfa1508394b6ac0";
  };
  buildInputs = [x11 (if pngSupport then libpng else null)];
  inherit pngSupport;
}
