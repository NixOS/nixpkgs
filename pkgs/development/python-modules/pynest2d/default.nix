{ lib, buildPythonPackage, fetchFromGitHub, python3, cmake
, pythonOlder, libnest2d, sip_4, clipper }:

buildPythonPackage rec {
  version = "4.10.0";
  pname = "pynest2d";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "pynest2d";
    rev = version;
    sha256 = "03aj0whxj9rs9nz3idld7w4vpmnr6vr40vpwmzcf5w2pi2n4z4lk";
  };

  propagatedBuildInputs = [ libnest2d sip_4 clipper ];
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
