{stdenv, fetchurl, zlib, openssl}:
stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "libre-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/re-${version}.tar.gz";
    sha256 = "18msdi5a1ssymz00w21hg6sgacb2lzx0ns31iapvk5hv6l225pd2";
  };
  buildInputs = [zlib openssl];
  makeFlags = [
    "USE_ZLIB=1" "USE_OPENSSL=1" 
    ''PREFIX=$(out)''
  ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.lib.getDev stdenv.cc.libc}"
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
