{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  pkg-config,
  validatePkgConfig,
  tinyxml-2,
  console-bridge,
  urdfdom-headers,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "urdfdom";
  version = "5.0.3";
=======
stdenv.mkDerivation rec {
  pname = "urdfdom";
  version = "4.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-WZA3rzulPO1Si/kFqGF+8si2kRC8xOhlparoO8CvN0g=";
=======
    rev = version;
    hash = "sha256-t1ff5aRHE7LuQdCXuooWPDUgPWjyYyQmQUB1RJmte1w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom/pull/142)
<<<<<<< HEAD
    ./cmake-install-absolute.patch
=======
    (fetchpatch {
      url = "https://github.com/ros/urdfdom/commit/61a7e35cd5abece97259e76aed8504052b2f5b53.patch";
      hash = "sha256-b3bEbbaSUDkwTEHJ8gVPEb+AR/zuWwLqiAW5g1T1dPU=";
    })
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];
  buildInputs = [
    tinyxml-2
    console-bridge
  ];
  propagatedBuildInputs = [ urdfdom-headers ];

<<<<<<< HEAD
  meta = {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
})
=======
  meta = with lib; {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
