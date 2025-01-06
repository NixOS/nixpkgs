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
  version = "2.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sPmOoR5K+gMfyPk2QMbiDNmWPRcqKrsz6ZPBAKR/3XY=";
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
