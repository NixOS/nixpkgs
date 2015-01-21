{ stdenv, fetchgit, cmake, opencv, qt5 }:

stdenv.mkDerivation rec {

  version = "0.5";
  name = "openbr-${version}";

  src = fetchgit {
    url = "https://github.com/biometrics/openbr.git";
    rev = "cc364a89a86698cd8d3052f42a3cb520c929b325";
    sha256 = "16b3mmsf9r1yqqaw89fx0c3bgfg86dz4phry89wqy2hw05szgda3";
  };

  buildInputs = [ opencv qt5 ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = {
    description = "Open Source Biometric Recognition";
    homepage = http://openbiometrics.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [flosse];
    platforms = with stdenv.lib.platforms; linux;
  };
}
