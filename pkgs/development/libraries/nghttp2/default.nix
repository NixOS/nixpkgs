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
  pname = "nghttp2";
  version = "1.37.0";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "1bi3aw096kd51abazvv6ilplz6gjbm84yr3mzxklbhysv38y6xl2";
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
  };
}
