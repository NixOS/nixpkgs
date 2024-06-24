{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  yajl,
}:

buildPythonPackage rec {
  pname = "jsonslicer";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "AMDmi3";
    repo = "jsonslicer";
    rev = version;
    hash = "sha256-uKIe/nJLCTe8WFIMB7+g3c0Yv3addgZEKYaBI6EpBSY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ yajl ];

  meta = with lib; {
    description = "Stream JSON parser for Python ";
    homepage = "https://github.com/AMDmi3/jsonslicer";
    license = licenses.mit;
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
