{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  validatePkgConfig,
}:

stdenv.mkDerivation rec {
  pname = "urdfdom-headers";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom_headers";
    rev = version;
    hash = "sha256-FQSnYuTc40MOxyFsMPfoCIonP+4AUQxdq74eoQ9tOoo=";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom_headers/pull/66)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom_headers/commit/6e0cea148c3a7123f8367cd48d5709a4490c32f1.patch";
      hash = "sha256-LC2TACGma/k6+WE9fTkzY98SgJYKsVuj5O9v84Q5mQ4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  meta = with lib; {
    description = "URDF (U-Robot Description Format) headers provides core data structure headers for URDF";
    homepage = "https://github.com/ros/urdfdom_headers";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
