{ stdenv, fetchurl
, cmake
, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "libproperties-cpp-${version}";
  version = "0.0.1";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/properties-cpp_0.0.1+14.10.20140730.orig.tar.gz";
    sha256 = "08vjyv7ibn6jh2ikj5v48kjpr3n6hlkp9qlvdn8r0vpiwzah0m2w";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [    ];

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
