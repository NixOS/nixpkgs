{lib, stdenv, fetchurl, zlib, openssl, libre}:
stdenv.mkDerivation rec {
  version = "0.6.0";
  pname = "librem";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/rem-${version}.tar.gz";
    sha256 = "0b17wma5w9acizk02isk5k83vv47vf1cf9zkmsc1ail677d20xj1";
  };
  buildInputs = [zlib openssl libre];
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    "PREFIX=$(out)"
  ]
  ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${lib.getDev stdenv.cc.cc}"
  ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    description = " A library for real-time audio and video processing";
    homepage = "http://www.creytiv.com/rem.html";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.bsd3;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/rem-.*[.]tar[.].*";
  };
}
