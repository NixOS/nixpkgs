{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, validatePkgConfig
, tinyxml-2, console-bridge, urdfdom-headers }:

stdenv.mkDerivation rec {
  pname = "urdfdom";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "ros";
    repo = pname;
    rev = version;
    hash = "sha256-IJdygkIC3efhUAjOywWIS/bmkMP//x4wI3fQfCX0gcQ=";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom/pull/142)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom/commit/61a7e35cd5abece97259e76aed8504052b2f5b53.patch";
      hash = "sha256-b3bEbbaSUDkwTEHJ8gVPEb+AR/zuWwLqiAW5g1T1dPU=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config validatePkgConfig ];
  buildInputs = [ tinyxml-2 console-bridge ];
  propagatedBuildInputs = [ urdfdom-headers ];

  meta = with lib; {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
