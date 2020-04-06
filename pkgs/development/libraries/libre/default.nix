{stdenv, fetchurl, zlib, openssl}:
stdenv.mkDerivation rec {
  version = "0.6.1";
  pname = "libre";
  src = fetchurl {
    url = "http://www.creytiv.com/pub/re-${version}.tar.gz";
    sha256 = "0hzyc0hdlw795nyx6ik7h2ihs8wapbj32x8c40xq0484ciwzqnyd";
  };
  buildInputs = [ zlib openssl ];
  makeFlags = [ "USE_ZLIB=1" "USE_OPENSSL=1" "PREFIX=$(out)" ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    description = "A library for real-time communications with async IO support and a complete SIP stack";
    homepage = "http://www.creytiv.com/re.html";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/re-.*[.]tar[.].*";
  };
}
