{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, validatePkgConfig }:

stdenv.mkDerivation rec {
  pname = "urdfdom-headers";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "urdfdom_headers";
    rev = version;
    sha256 = "1abzhcyv2vad8l36vy0fcz9kpgns834la7hf9zal962bwycqnkmg";
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom_headers/pull/66)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom_headers/commit/990fd233b1a3ff68872a3552f3ea5ccbe105848c.patch";
      sha256 = "1hxf2kw3mkll3fzvsby104b2m854bdpiy9gr3r9ysmw2r537gqdy";
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
