{stdenv, fetchurl, unicodeSupport ? false, cplusplusSupport ? true}:

stdenv.mkDerivation {
  name = "pcre-7.4";
  src = fetchurl {
    url = mirror://sourceforge/pcre/pcre-7.4.tar.bz2;
    sha256 = "1rdks2h5f3p2d71c4jnxaic1c9gmgsfky80djnafcdbdrhzkiyx5";
  };
  configureFlags =
    (if unicodeSupport then
      "--enable-unicode-properties --enable-shared --disable-static"
    else "") +
    (if !cplusplusSupport then "--disable-cpp" else "");
}
