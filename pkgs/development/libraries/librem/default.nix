{stdenv, fetchurl, zlib, openssl, libre}:
stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "librem-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/rem-${version}.tar.gz";
    sha256 = "0b17wma5w9acizk02isk5k83vv47vf1cf9zkmsc1ail677d20xj1";
  };
  buildInputs = [zlib openssl libre];
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    ''PREFIX=$(out)''
  ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.lib.getDev stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    homepage = http://www.creytiv.com/rem.html;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.bsd3;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/rem-.*[.]tar[.].*";
  };
}
