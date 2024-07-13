{ lib, stdenv, fetchFromGitHub, cmake, eigen, boost, libnabo, yaml-cpp }:

stdenv.mkDerivation rec {
  pname = "libpointmatcher";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "norlab-ulaval";
    repo = "libpointmatcher";
    rev = version;
    hash = "sha256-XXkvBxG9f8rW1O968+2R+gltMSRGqH225vOmzp6Tpb8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen boost libnabo yaml-cpp ];

  cmakeFlags = [
    (lib.cmakeFeature "EIGEN_INCLUDE_DIR" "${eigen}/include/eigen3")
    (lib.cmakeBool "BUILD_TESTS" doCheck)
  ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "\"Iterative Closest Point\" library for 2-D/3-D mapping in robotic";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cryptix ];
  };
}
