{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  validatePkgConfig,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "urdfdom-headers";
  version = "2.0.1";
=======
stdenv.mkDerivation rec {
  pname = "urdfdom-headers";
  version = "1.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom_headers";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-tBNoG5gH3haZETUlI4Pn1mg14T/sMil9n/iSzjJC+Rg=";
=======
    rev = version;
    hash = "sha256-FQSnYuTc40MOxyFsMPfoCIonP+4AUQxdq74eoQ9tOoo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom_headers/pull/66)
    (fetchpatch {
<<<<<<< HEAD
      url = "https://github.com/ros/urdfdom_headers/commit/fa89f2d4744839827f41579004537c966a097681.patch";
      hash = "sha256-w6PPKCpbR4dGsudVEz+SO9ylXVayLPRAl3VvpMt4DHo=";
=======
      url = "https://github.com/ros/urdfdom_headers/commit/6e0cea148c3a7123f8367cd48d5709a4490c32f1.patch";
      hash = "sha256-LC2TACGma/k6+WE9fTkzY98SgJYKsVuj5O9v84Q5mQ4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

<<<<<<< HEAD
  meta = {
    description = "URDF (U-Robot Description Format) headers provides core data structure headers for URDF";
    homepage = "https://github.com/ros/urdfdom_headers";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
})
=======
  meta = with lib; {
    description = "URDF (U-Robot Description Format) headers provides core data structure headers for URDF";
    homepage = "https://github.com/ros/urdfdom_headers";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
