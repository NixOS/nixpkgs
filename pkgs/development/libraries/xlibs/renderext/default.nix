{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "renderext-0.9";
  src = fetchurl {
    url = http://xlibs.freedesktop.org/release/renderext-0.9.tar.bz2;
    md5 = "d43c2afc69937655d13c02588c9ff974";
  };
}
