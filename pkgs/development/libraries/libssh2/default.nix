{stdenv, fetchurlBoot, openssl, zlib, windows}:

stdenv.mkDerivation rec {
  name = "libssh2-1.7.0";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "116mh112w48vv9k3f15ggp5kxw5sj4b88dzb5j69llsh7ba1ymp4";
  };

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [ openssl zlib ];

  crossAttrs = {
    # link against cross-built libraries
    configureFlags = [
      "--with-openssl"
      "--with-libssl-prefix=${openssl.crossDrv}"
      "--with-libz"
      "--with-libz-prefix=${zlib.crossDrv}"
    ];
  } // stdenv.lib.optionalAttrs (stdenv.cross.libc == "msvcrt") {
    # mingw needs import library of ws2_32 to build the shared library
    preConfigure = ''
      export LDFLAGS="-L${windows.mingw_w64}/lib $LDFLAGS"
    '';
  };

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
