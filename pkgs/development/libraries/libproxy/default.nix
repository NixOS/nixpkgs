{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, dbus, networkmanager, webkitgtk216x, pcre, python2 }:

stdenv.mkDerivation rec {
  name = "libproxy-${version}";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    sha256 = "0yg4wr44ync6x3p107ic00m1l04xqhni9jn1vzvkw3nfjd0k6f92";
  };

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ dbus networkmanager webkitgtk216x pcre ];

  cmakeFlags = [
    "-DWITH_WEBKIT3=ON"
    "-DWITH_MOZJS=OFF"
    "-DPYTHON_SITEPKG_DIR=$(out)/${python2.sitePackages}"
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.lgpl21;
    homepage = "http://libproxy.github.io/libproxy/";
    description = "A library that provides automatic proxy configuration management";
  };
}
