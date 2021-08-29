{ lib, stdenv, fetchFromGitHub, cmake, validatePkgConfig }:

stdenv.mkDerivation rec {
  pname = "console-bridge";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "console_bridge";
    rev = version;
    sha256 = "18qycrjnf7v8n5bipij91jsv7ap98z5dsp93w2gz9rah4lfjb80q";
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
