{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, cmake
, dbus, networkmanager, spidermonkey_38, pcre, python2, python3, zlib, darwin }:

stdenv.mkDerivation rec {
  name = "libproxy-${version}";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    sha256 = "10swd3x576pinx33iwsbd4h15fbh2snmfxzcmab4c56nb08qlbrs";
  };

  patches = [ ./files/apple-webkit-disable.patch ];

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ dbus pcre python2 python3 ]
   ++ lib.optionals stdenv.isLinux [ networkmanager spidermonkey_38 ]
   ++ lib.optionals stdenv.isDarwin [
     zlib
     darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  cmakeFlags = lib.optional stdenv.isLinux "-DWITH_MOZJS=ON"
    ++ lib.optionals stdenv.isDarwin [
      "-DWITH_WEBKIT=OFF"
      "-DWITH_WEBKIT3=OFF"
    ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DPYTHON2_SITEPKG_DIR=$out/${python2.sitePackages}"
      "-DPYTHON3_SITEPKG_DIR=$out/${python3.sitePackages}"
    )
  '';

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    license = licenses.lgpl21;
    homepage = http://libproxy.github.io/libproxy/;
    description = "A library that provides automatic proxy configuration management";
  };
}
