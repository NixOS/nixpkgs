{stdenv, fetchurl, zlib, openssl}:
stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "libre-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/re-${version}.tar.gz";
    sha256 = "1c99ygs46qhd4a0ardxhdyjaw5p8clhzmsm8jydqxnmbakwy518m";
  };
  buildInputs = [zlib openssl];
  makeFlags = [
    "USE_ZLIB=1" "USE_OPENSSL=1" 
    ''PREFIX=$(out)''
  ]
  ++ stdenv.lib.optional (stdenv.gcc.gcc != null) "SYSROOT_ALT=${stdenv.gcc.gcc}"
  ++ stdenv.lib.optional (stdenv.gcc.libc != null) "SYSROOT=${stdenv.gcc.libc}"
  ;
  meta = {
    homepage = "http://www.creytiv.com/re.html";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = with stdenv.lib.licenses; bsd3;
  };
}
