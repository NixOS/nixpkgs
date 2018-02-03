{ stdenv, fetchurlBoot, pkgconfig, autoreconfHook, cunit }:

# INFO: fetchurl depends on curl which depends on this library

stdenv.mkDerivation rec {
  name = "libnghttp2-${version}";
  version = "1.28.0";

  # Don't use fetchFromGitHub or fetchurl since this needs a bootstrap curl
  src = fetchurlBoot {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.xz";
    sha256 = "13gxk72manbmaaf3mahvihfw71zas1m7z8j2bs9s7v2dc403yv0d";
  };

  outputs = [ "out" "dev" ];

  # https://nghttp2.org/documentation/package_README.html#requirements
  nativeBuildInputs = [ autoreconfHook cunit pkgconfig ];

  # adaptation of https://svnweb.freebsd.org/ports/head/www/libnghttp2/files/patch-Makefile.am
  patches = [ ./libonly-Makefile.patch ];

  configureFlags = [
    "--enable-lib-only"
    "--disable-examples"
    "--disable-python-bindings"
    "--disable-asio-lib"
    "--disable-hpack-tools"
  ];

  enableParallelBuilding = true;

  doCheck = true;  # requires CUnit

  meta = with stdenv.lib; {
    homepage = https://nghttp2.org/;
    description = "A C implementation of the HyperText Transfer Protocol version 2";
    longDescription = ''
      HTTP/2 C Library and Tools.

      NOTE: this is only the C library and development files. The tools are available in the "nghttp2" package.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ c0bw3b wkennington ];
  };
}
