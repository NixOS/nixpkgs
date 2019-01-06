{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, openssl ? null, libev ? null, zlib ? null, c-ares ? null
, enableHpack ? false, jansson ? null
, enableAsioLib ? false, boost ? null
, enableGetAssets ? false, libxml2 ? null
, enableJemalloc ? false, jemalloc ? null
, enableApp ? !stdenv.hostPlatform.isWindows
}:

assert enableHpack -> jansson != null;
assert enableAsioLib -> boost != null;
assert enableGetAssets -> libxml2 != null;
assert enableJemalloc -> jemalloc != null;

let inherit (stdenv.lib) optional; in

stdenv.mkDerivation rec {
  name = "nghttp2-${version}";
  version = "1.35.1";

  src = fetchurl {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.bz2";
    sha256 = "020k9xkca386yfs47zypb4x83f4l6vqpf8qw1xrhmrd29x4wxvam";
  };

  outputs = [ "bin" "out" "dev" "lib" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libev zlib c-ares ]
    ++ optional enableHpack jansson
    ++ optional enableAsioLib boost
    ++ optional enableGetAssets libxml2
    ++ optional enableJemalloc jemalloc;

  enableParallelBuilding = true;

  configureFlags = [
    "--with-spdylay=no"
    "--disable-examples"
    "--disable-python-bindings"
    (stdenv.lib.enableFeature enableApp "app")
  ] ++ optional enableAsioLib "--enable-asio-lib --with-boost-libdir=${boost}/lib";

  #doCheck = true;  # requires CUnit ; currently failing at test_util_localtime_date in util_test.cc

  meta = with stdenv.lib; {
    homepage = https://nghttp2.org/;
    description = "A C implementation of HTTP/2";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
