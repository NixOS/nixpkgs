{ stdenv, lib, fetchurlBoot, openssl, zlib, windows
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

  # Hack: when cross-compiling we need to manually add rpaths to ensure that
  # the linker can find find zlib and openssl when linking the testsuite.
  NIX_LDFLAGS =
    if stdenv.hostPlatform != stdenv.buildPlatform
    then '' -rpath-link ${lib.getLib zlib}/lib
            -rpath-link ${lib.getLib openssl}/lib ''
    else null;

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
