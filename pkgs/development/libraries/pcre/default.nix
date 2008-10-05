{stdenv, fetchurl, unicodeSupport ? false, cplusplusSupport ? true}:

stdenv.mkDerivation {
  name = "pcre-7.7";
  src = fetchurl {
    url = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.7.tar.bz2;
    sha256 = "0h7nkm68bv305v3qyh12jj63xw4nr5i9p2b8xr2vna5lhgs89nms";
  };
  configureFlags =
    (if unicodeSupport then
      "--enable-unicode-properties --enable-shared --disable-static"
    else "") +
    (if !cplusplusSupport then "--disable-cpp" else "");
}
