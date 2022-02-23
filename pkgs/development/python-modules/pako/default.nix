{ lib
, buildPythonPackage
, fetchPypi
, appdirs
}:

let
  pname = "pako";
  version = "0.3.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wDOgc7uBjKM2rh/MuiZVvWDf53dE+F1FF6vTFg1yIx8=";
  };

  propagatedBuildInputs = [
    appdirs
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "pako"
  ];

  meta = with lib; {
    description = "The universal package manager library";
    homepage = "https://github.com/MycroftAI/pako";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
  };
}
