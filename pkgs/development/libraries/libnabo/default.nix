{stdenv, fetchFromGitHub, cmake, eigen, boost}:

stdenv.mkDerivation rec {
  version = "1.0.7";
  name = "libnabo-${version}";

  src = fetchFromGitHub {
    owner = "ethz-asl";
    repo = "libnabo";
    rev = version;
    sha256 = "17vxlmszzpm95vvfdxnm98d5p297i10fyblblj6kf0ynq8r2mpsh";
  };

  buildInputs = [cmake eigen boost];

  enableParallelBuilding = true;

  cmakeFlags = "
    -DEIGEN_INCLUDE_DIR=${eigen}/include/eigen3
  ";

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A fast K Nearest Neighbor library for low-dimensional spaces";
    license = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cryptix ];
  };
}
