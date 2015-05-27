{ stdenv, fetchurl, libre, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "librem-${version}";
  version = "0.4.6";

  src = fetchurl {
    url = "http://www.creytiv.com/pub/rem-${version}.tar.gz";
    sha256 = "0rgqy9pqn730ijxvz1gk0virsf6jwjmq02s99jqqrfm3p0g6zs3w";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "LIBRE_INC=${libre}/include/re"
    "LIBRE_MK=${libre}/share/re/re.mk"
  ] ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
    ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}";

  buildInputs = [ libre openssl zlib ];

  postInstall = ''
    # Remove static object
    rm -f $out/lib/librem.a
  '';

  meta = with stdenv.lib; {
    description = "Portable generic library for real-time audio and video processing";
    homepage = http://www.creytiv.com/rem.html;
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
