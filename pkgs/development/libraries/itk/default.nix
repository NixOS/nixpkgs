{stdenv, fetchurl, cmake, libX11, libuuid, xz}:

#TODO let version = 4.7.1 in

stdenv.mkDerivation rec {
  name = "itk-4.7.1";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-4.7.1.tar.xz;
    sha256 = "9f7b45ec57e01ca9ad89a05411752914f810fd70b7038fc48abd59e3ec13c6ee";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_CXX_FLAGS=-fPIC"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [ libX11 libuuid ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = http://www.itk.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric bcdarwin];
    platforms = with stdenv.lib.platforms; linux;
  };
}
