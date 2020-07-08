{ lib, stdenv, fetchFromGitHub, cmake, validatePkgConfig }:

stdenv.mkDerivation rec {
  pname = "console-bridge";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "console_bridge";
    rev = version;
    sha256 = "14f5i2qgp5clwkm8jjlvv7kxvwx52a607mnbc63x61kx9h6ymxlk";
  };

  nativeBuildInputs = [ cmake validatePkgConfig ];

  meta = with lib; {
    description = "A ROS-independent package for logging that seamlessly pipes into rosconsole/rosout for ROS-dependent packages";
    homepage = "https://github.com/ros/console_bridge";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
