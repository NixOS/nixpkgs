{ lib, stdenv, buildPythonPackage, fetchFromGitHub, python3, cmake
, pythonOlder, libnest2d, sip, clipper }:

buildPythonPackage rec {
  version = "4.8.0";
  pname = "pynest2d";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "pynest2d";
    rev = version;
    sha256 = "18dn92vgr4gvf9scfh93yg9bwrhdjvq62di08rpi7pqjrrvq2nvp";
  };

  propagatedBuildInputs = [ libnest2d sip clipper ];
  nativeBuildInputs = [ cmake ];

  CLIPPER_PATH = "${clipper.out}";

  postPatch = ''
     sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python3.sitePackages}#' cmake/SIPMacros.cmake
   '';

  meta = with lib; {
    description = "Python bindings for libnest2d";
    homepage = "https://github.com/Ultimaker/pynest2d";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
