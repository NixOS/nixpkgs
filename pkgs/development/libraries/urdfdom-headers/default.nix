{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, validatePkgConfig }:

stdenv.mkDerivation rec {
  pname = "urdfdom-headers";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom_headers";
    rev = version;
    hash = "sha256-ry5wDMRxR7TtupUghe9t1XP0XMvWKiOesO5RFHPrSdI=";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom_headers/pull/66)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom_headers/commit/c9c993147bbf18d5ec83bae684c5780281e529b4.patch";
      hash = "sha256-BnYPdcetYSim2O1R38N0d1tY0Id++AgKNic8+dlM6Vg=";
    })
  ];

  nativeBuildInputs = [ cmake validatePkgConfig ];

  meta = with lib; {
    description = "URDF (U-Robot Description Format) headers provides core data structure headers for URDF";
    homepage = "https://github.com/ros/urdfdom_headers";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
