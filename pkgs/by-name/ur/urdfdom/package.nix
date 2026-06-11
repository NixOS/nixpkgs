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
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom";
    tag = finalAttrs.version;
    hash = "sha256-52Iv9ltYaGr6Ys3FreBSHOfJnVEp7kwjBpi8Cm6aC/g=";
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

  meta = {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
})
