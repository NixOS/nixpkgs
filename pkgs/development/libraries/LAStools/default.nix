{ stdenv, fetchFromGitHub, cmake, fetchurl}:
stdenv.mkDerivation rec {

  version = "180812";
  name = "LAStools-${version}";

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    rev = "162cf032f25cac492712a8568a08b224a5fb40c2";
    sha256 = "117c9csbfwsx424ha695l7d99cswi316k8q338mzk1lxlk8p3xbz";
  };

  nativeBuildInputs = [cmake];

  meta = {
    description = "Efficient tools for LiDAR processing.";
    homepage = https://www.laszip.org;
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.mpickering ];
    platforms = stdenv.lib.platforms.unix;
  };
}
