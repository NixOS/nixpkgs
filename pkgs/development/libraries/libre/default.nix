{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "libre-${version}";
  version = "0.4.12";

  src = fetchurl {
    url = "http://www.creytiv.com/pub/re-${version}.tar.gz";
    sha256 = "1wjdcf5wr50d86rysj5haz53v7d58j7sszpc6k5b4mn1x6604i0d";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "USE_OPENSSL=1"
    "USE_ZLIB=1"
  ] ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
    ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}";

  buildInputs = [ openssl zlib ];

  postInstall = ''
    # Remove static object
    rm -f $out/lib/libre.a
  '';

  meta = with stdenv.lib; {
    description = "Portable generic library for real-time communications";
    homepage = http://www.creytiv.com/re.html;
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
