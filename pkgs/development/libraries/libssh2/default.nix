{stdenv, fetchurlBoot, openssl, zlib, windows}:

stdenv.mkDerivation rec {
  name = "libssh2-1.6.0";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "05c2is69c50lyikkh29nk6zhghjk4i7hjx0zqfhq47aald1jj82s";
  };

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
