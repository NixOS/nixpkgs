{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, validatePkgConfig }:

stdenv.mkDerivation rec {
  pname = "urdfdom-headers";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom_headers";
    rev = version;
    hash = "sha256-tM5tUq/wGzjH4kZWXtF91LoBQTKejUZP6ArF1dzbSqg=";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom_headers/pull/66)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom_headers/commit/fa89f2d4744839827f41579004537c966a097681.patch";
      hash = "sha256-w6PPKCpbR4dGsudVEz+SO9ylXVayLPRAl3VvpMt4DHo=";
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
