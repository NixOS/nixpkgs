{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  robotframework,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "robotsuite";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3lKSPeZdq1z9umtiEAEQO7jVL6zRS/rCt76ildDe90U=";
  };

  propagatedBuildInputs = [
    robotframework
    lxml
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = lib.licenses.gpl3Only;
  };
}
