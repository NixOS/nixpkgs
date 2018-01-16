{ stdenv, fetchurl
, dbus
, boost
, cmake
, pkgconfig
, libxml2
, lcov
, gmock
, libprocess-cpp
, libproperties-cpp
}:

stdenv.mkDerivation rec {
  name = "dbus-cpp-${version}";
  version = "5.0.0";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/dbus-cpp_5.0.0+16.10.20160809.orig.tar.gz";
    sha256 = "1d0k65yfaxwvmskrcl3li5g0ylaj0k9sz2n19l7q5qlrl33v5lrf";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ dbus dbus.dev boost libxml2 lcov gmock libprocess-cpp libproperties-cpp];
  sourceRoot = ".";
  cmakeFlags = [
    "-DDBUS_CPP_VERSION_MAJOR=5"
    "-DDBUS_CPP_VERSION_MINOR=0"
    "-DDBUS_CPP_VERSION_PATCH=0"
  ];

  patchPhase = ''
    truncate -s 0 tests/CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    homepage = http://dbus-cplusplus.sourceforge.net;
    description = "C++ API for D-BUS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
