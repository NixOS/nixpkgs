{stdenv, fetchurl, zlib, openssl, libre}:
stdenv.mkDerivation rec {
  version = "0.4.6";
  name = "librem-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/rem-${version}.tar.gz";
    sha256 = "0rgqy9pqn730ijxvz1gk0virsf6jwjmq02s99jqqrfm3p0g6zs3w";
  };
  buildInputs = [zlib openssl libre];
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    ''PREFIX=$(out)''
  ]
  ++ stdenv.lib.optional (stdenv.cc.gcc != null) "SYSROOT_ALT=${stdenv.cc.gcc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;
  meta = {
    homepage = "http://www.creytiv.com/rem.html";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = with stdenv.lib.licenses; bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/rem-.*[.]tar[.].*";
  };
}
