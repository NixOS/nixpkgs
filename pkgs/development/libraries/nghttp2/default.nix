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
, enablePython ? false, python ? null, cython ? null, ncurses ? null, setuptools ? null
}:

assert enableHpack -> jansson != null;
assert enableAsioLib -> boost != null;
assert enableGetAssets -> libxml2 != null;
assert enableJemalloc -> jemalloc != null;
assert enablePython -> python != null && cython != null && ncurses != null && setuptools != null;

let inherit (stdenv.lib) optional optionals optionalString; in

stdenv.mkDerivation rec {
  pname = "nghttp2";
  version = "1.40.0";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "0kyrgd4s2pq51ps5z385kw1hn62m8qp7c4h6im0g4ibrf89qwxc2";
  };

  outputs = [ "bin" "out" "dev" "lib" ]
    ++ optional enablePython "python";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
    ++ optional enableLibEv libev
    ++ [ zlib ]
    ++ optional enableCAres c-ares
    ++ optional enableHpack jansson
    ++ optional enableAsioLib boost
    ++ optional enableGetAssets libxml2
    ++ optional enableJemalloc jemalloc
    ++ optionals enablePython [ python ncurses setuptools ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-spdylay=no"
    "--disable-examples"
    (stdenv.lib.enableFeature enableApp "app")
  ] ++ optional enableAsioLib "--enable-asio-lib --with-boost-libdir=${boost}/lib"
    ++ (if enablePython then [
    "--with-cython=${cython}/bin/cython"
  ] else [
    "--disable-python-bindings"
  ]);

  preInstall = optionalString enablePython ''
    mkdir -p $out/${python.sitePackages}
    # convince installer it's ok to install here
    export PYTHONPATH="$PYTHONPATH:$out/${python.sitePackages}"
  '';
  postInstall = optionalString enablePython ''
    mkdir -p $python/${python.sitePackages}
    mv $out/${python.sitePackages}/* $python/${python.sitePackages}
  '';

  #doCheck = true;  # requires CUnit ; currently failing at test_util_localtime_date in util_test.cc

  meta = with stdenv.lib; {
    homepage = "https://nghttp2.org/";
    description = "A C implementation of HTTP/2";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
