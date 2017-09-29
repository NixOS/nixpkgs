{ stdenv, fetchurlBoot, openssl, zlib, windows
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "libssh2-1.8.0";

  src = fetchurlBoot {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "1m3n8spv79qhjq4yi0wgly5s5rc8783jb1pyra9bkx1md0plxwrr";
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
  } // stdenv.lib.optionalAttrs (hostPlatform.libc == "msvcrt") {
    # mingw needs import library of ws2_32 to build the shared library
    preConfigure = ''
      export LDFLAGS="-L${windows.mingw_w64}/lib $LDFLAGS"
    '';
  };

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
