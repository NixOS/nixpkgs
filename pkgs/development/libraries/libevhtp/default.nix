{ stdenv, fetchurl, libevent, cmake, openssl }:

stdenv.mkDerivation rec
{
  version = "1.2.9";
  name = "libevhtp-${version}";

  src = fetchurl
  {
    url = "https://github.com/ellzey/libevhtp/archive/${version}.tar.gz";
    sha256 = "0z59qjrmz20ifb7ak03bvj2bxbpl038vd6301dgbw4ajmdfi4iba";
  };

  configurePhase = ''
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$out \
      -DOPENSSL_INCLUDE_DIR=${openssl}/include \
      -DLIBEVENT_OPENSSL_LIBRARY=${openssl}/lib ..
  '';

  buildInputs = [ libevent cmake openssl ];

  meta =
  {
    homepage = "https://github.com/ellzey/libevhtp";
    description = "A more flexible replacement for libevent's httpd API";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.matejc ];
  };
}
