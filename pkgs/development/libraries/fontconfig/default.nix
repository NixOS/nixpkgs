{stdenv, fetchurl, x11, freetype, expat, ed}:

assert x11 != null && x11.buildClientLibs;
assert freetype != null;
assert expat != null;
assert ed != null;

stdenv.mkDerivation {
  name = "fontconfig-2.2.90";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://pdx.freedesktop.org/software/fontconfig/releases/fontconfig-2.2.90.tar.gz;
    md5 = "5cb87476743be1bbf1674ed72a76ae6a";
  };
  x11 = x11;
  freetype = freetype;
  expat = expat;
  ed = ed;
}
