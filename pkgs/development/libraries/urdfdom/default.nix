{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, validatePkgConfig
<<<<<<< HEAD
, urdfdom-headers, console-bridge, tinyxml }:

stdenv.mkDerivation rec {
  pname = "urdfdom";
  version = "3.1.1";
=======
, tinyxml, boost, urdfdom-headers, console-bridge }:

stdenv.mkDerivation rec {
  pname = "urdfdom";
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ros";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-UdkGJAXK3Q8QJaqMZBA5/FKUgWq9EVeqkqwVewTlTD8=";
=======
    hash = "sha256-9MJnify4zcDBSZVJZCN/XupN5xax+U4PLee54gVVw3Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom/pull/142)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom/commit/cbe6884d267779463bb444be851f6404e692cc0a.patch";
      hash = "sha256-1gTRKIGqiSRion76bGecSfFJSBskYUJguUIa6ePIiX4=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config validatePkgConfig ];
<<<<<<< HEAD
  propagatedBuildInputs = [ urdfdom-headers console-bridge tinyxml ];
=======
  buildInputs = [ tinyxml boost ];
  propagatedBuildInputs = [ urdfdom-headers console-bridge ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
