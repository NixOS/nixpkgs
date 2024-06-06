{lib, stdenv, fetchFromGitHub, cmake, eigen, boost}:

stdenv.mkDerivation rec {
  version = "1.1.1";
  pname = "libnabo";

  src = fetchFromGitHub {
    owner = "ethz-asl";
    repo = "libnabo";
    rev = version;
    sha256 = "sha256-EVbvNwj1aRhRr5PhF6Kkb/UTn4JzF174WX1C+tvBv2Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen boost ];

  cmakeFlags = [
    "-DEIGEN_INCLUDE_DIR=${eigen}/include/eigen3"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A fast K Nearest Neighbor library for low-dimensional spaces";
    license = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cryptix ];
  };
}
