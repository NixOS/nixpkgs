{stdenv, fetchurl, cmake, libX11, libuuid}:

stdenv.mkDerivation rec {
  name = "itk-3.16.0";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-3.16.0.tar.gz;
    sha256 = "18r021ib2g94qlajjsny0r6cpc61rmr0zrpb2l0mx1y7j9ckr6ks";
  };

  cmakeFlags = [ "-DBUILD_TESTING=OFF" "-DBUILD_EXAMPLES=OFF" ];

  # makeFlags = [ "VERBOSE=1" ];

  buildInputs = [ cmake libX11 libuuid ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = http://www.itk.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
