{ lib
, buildPythonPackage
, fetchPypi
, lxml
, robotframework
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "robotsuite";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iugVKUPl6HTTO8K1EbSqAk1fl/fsEPoOcsOnnAgcEas=";
  };

  propagatedBuildInputs = [ robotframework lxml six ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = licenses.gpl3;
  };
}
