{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, openssl ? null, zlib ? null
, enableLibEv ? !stdenv.hostPlatform.isWindows, libev ? null
, enableCAres ? !stdenv.hostPlatform.isWindows, c-ares ? null
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
  pname = "nghttp2";
  version = "1.40.0";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "0kyrgd4s2pq51ps5z385kw1hn62m8qp7c4h6im0g4ibrf89qwxc2";
  };

  outputs = [ "bin" "out" "dev" "lib" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
    ++ optional enableLibEv libev
    ++ [ zlib ]
    ++ optional enableCAres c-ares
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
  };
}
