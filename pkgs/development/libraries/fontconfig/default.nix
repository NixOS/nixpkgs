{stdenv, fetchurl, x11, freetype, expat, ed}:

assert !isNull x11 && x11.buildClientLibs;
assert !isNull freetype;
assert !isNull expat;
assert !isNull ed;

derivation {
  name = "fontconfig-2.2.90";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://pdx.freedesktop.org/software/fontconfig/releases/fontconfig-2.2.90.tar.gz;
    md5 = "5cb87476743be1bbf1674ed72a76ae6a";
  };
  stdenv = stdenv;
  x11 = x11;
  freetype = freetype;
  expat = expat;
  ed = ed;
}
