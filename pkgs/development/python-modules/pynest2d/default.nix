{ lib, buildPythonPackage, fetchFromGitHub, python, cmake
, libnest2d, sip_4, clipper }:

buildPythonPackage rec {
  version = "4.12.0";
  pname = "pynest2d";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "pynest2d";
    rev = version;
    sha256 = "sha256-QQdTDhO4i9NVhegGTmdEQSNv3gooaZzTX/Rv86h3GEo=";
  };

  propagatedBuildInputs = [ libnest2d sip_4 clipper ];
  nativeBuildInputs = [ cmake ];

  CLIPPER_PATH = "${clipper.out}";

  postPatch = ''
     sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
   '';

  meta = with lib; {
    description = "Python bindings for libnest2d";
    homepage = "https://github.com/Ultimaker/pynest2d";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
