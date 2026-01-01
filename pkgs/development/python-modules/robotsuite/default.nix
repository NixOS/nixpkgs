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

<<<<<<< HEAD
  meta = {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = lib.licenses.gpl3Only;
=======
  meta = with lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
