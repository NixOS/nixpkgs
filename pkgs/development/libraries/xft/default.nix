{stdenv, fetchurl, pkgconfig, x11, fontconfig}:

assert pkgconfig != null && x11 != null && fontconfig != null;
assert fontconfig.x11 == x11;

stdenv.mkDerivation {
  name = "xft-2.1.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://pdx.freedesktop.org/software/fontconfig/releases/xft-2.1.2.tar.gz;
    md5 = "defb7e801d4938b8b15a426ae57e2f3f";
  };
  pkgconfig = pkgconfig;
  x11 = x11;
  fontconfig = fontconfig;
}
