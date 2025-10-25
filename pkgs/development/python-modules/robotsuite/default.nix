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
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gy10/yRKuYIPneLTErmjZoBZAEp6tAzNRqrn8NuYdvo=";
  };

  propagatedBuildInputs = [
    robotframework
    lxml
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = licenses.gpl3Only;
  };
}
