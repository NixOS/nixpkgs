{stdenv, fetchFromGitHub, cmake, eigen, boost}:

stdenv.mkDerivation rec {
  version = "1.0.6";
  name = "libnabo-${version}";

  src = fetchFromGitHub {
    owner = "ethz-asl";
    repo = "libnabo";
    rev = version;
    sha256 = "1pg4vjfq5n7zhjdf7rgvycd7bkk1iwr50fl2dljq43airxz6525w";
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
