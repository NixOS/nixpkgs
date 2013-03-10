{stdenv, fetchurl, cmake, libX11, libuuid, xz}:

stdenv.mkDerivation rec {
  name = "itk-4.0.0";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-4.0.0.tar.xz;
    sha256 = "05z49sw612cbyiaghcsda0xylrkf06jh81ql79si5632w1hpgbd9";
  };

  cmakeFlags = [ "-DBUILD_TESTING=OFF" "-DBUILD_EXAMPLES=OFF" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [ libX11 libuuid ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = http://www.itk.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
