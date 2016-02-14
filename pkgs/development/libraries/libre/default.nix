{stdenv, fetchurl, zlib, openssl}:
stdenv.mkDerivation rec {
  version = "0.4.15";
  name = "libre-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/re-${version}.tar.gz";
    sha256 = "0yvjc3hvjk29irdii2h1hpq4cg9l1c71jfvglz67y1pc89z63yax";
  };
  buildInputs = [zlib openssl];
  makeFlags = [
    "USE_ZLIB=1" "USE_OPENSSL=1" 
    ''PREFIX=$(out)''
  ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;
  meta = {
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
