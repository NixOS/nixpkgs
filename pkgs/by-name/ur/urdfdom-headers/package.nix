{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "urdfdom-headers";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom_headers";
    tag = finalAttrs.version;
    hash = "sha256-tBNoG5gH3haZETUlI4Pn1mg14T/sMil9n/iSzjJC+Rg=";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom_headers/pull/66)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom_headers/commit/fa89f2d4744839827f41579004537c966a097681.patch";
      hash = "sha256-w6PPKCpbR4dGsudVEz+SO9ylXVayLPRAl3VvpMt4DHo=";
    })
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  meta = {
    description = "URDF (U-Robot Description Format) headers provides core data structure headers for URDF";
    homepage = "https://github.com/ros/urdfdom_headers";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
})
