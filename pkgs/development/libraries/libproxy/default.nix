{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, dbus, networkmanager, spidermonkey_38, pcre, python2, python3 }:

stdenv.mkDerivation rec {
  name = "libproxy-${version}";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    sha256 = "10swd3x576pinx33iwsbd4h15fbh2snmfxzcmab4c56nb08qlbrs";
  };

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ dbus networkmanager spidermonkey_38 pcre python2 python3 ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DWITH_MOZJS=ON"
      "-DPYTHON2_SITEPKG_DIR=$out/${python2.sitePackages}"
      "-DPYTHON3_SITEPKG_DIR=$out/${python3.sitePackages}"
    )
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.lgpl21;
    homepage = http://libproxy.github.io/libproxy/;
    description = "A library that provides automatic proxy configuration management";
  };
}
