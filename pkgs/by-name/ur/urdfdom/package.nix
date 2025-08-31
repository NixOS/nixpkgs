{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  validatePkgConfig,
  tinyxml-2,
  console-bridge,
  urdfdom-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "urdfdom";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom";
    tag = finalAttrs.version;
    hash = "sha256-Df7njCd1W373R2XU6Jh15HlfFHhHM+ErivGiK/95Aak=";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom/pull/142)
    ./cmake-install-absolute.patch
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

  meta = with lib; {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
})
