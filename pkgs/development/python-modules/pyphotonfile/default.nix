{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, numpy
}:
let
  version = "0.2.1+";
in
buildPythonPackage {
  pname = "pyphotonfile";
  format = "setuptools";
  inherit version;

  dontUseSetuptoolsCheck = true;
  propagatedBuildInputs = [ pillow numpy ];

  src = fetchFromGitHub {
    owner = "cab404";
    repo = "pyphotonfile";
    rev = "b7ee92a0071007bb1d6a5984262651beec26543d";
    sha256 = "iB5ky4fPX8ZnvXlDpggqS/345k2x/mPC4cIgb9M0f/c=";
  };

  meta = with lib; {
    maintainers = [ maintainers.cab404 ];
    license = licenses.gpl3Plus;
    description = "Library for reading and writing files for the Anycubic Photon 3D-Printer";
    homepage = "https://github.com/cab404/pyphotonfile";
  };

}
