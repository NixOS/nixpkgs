{stdenv, fetchurl, zlib, openssl}:
stdenv.mkDerivation rec {
  version = "0.5.8";
  name = "libre-${version}";
  src = fetchurl {
    url = "http://www.creytiv.com/pub/re-${version}.tar.gz";
    sha256 = "0w0f8j43j0nzgvkmv3ayzrssppgjmsh6z8mpa5iqsz8nv99dc3qr";
  };
  buildInputs = [ zlib openssl ];
  makeFlags = [ "USE_ZLIB=1" "USE_OPENSSL=1" "PREFIX=$(out)" ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    homepage = http://www.creytiv.com/re.html;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/re-.*[.]tar[.].*";
  };
}
