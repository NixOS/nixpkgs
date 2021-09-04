{ lib, fetchPypi, buildPythonPackage, pytest, pytest-html }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83ce5fa87d1b37a690106aedf58a12d0d16758f38f73336f2c703e2bfe01d7db";
  };

  checkInputs = [ pytest pytest-html ];
  checkPhase = "pytest tests/*/*.py";

  meta = with lib; {
    homepage = "https://github.com/cucumber/tag-expressions-python";
    description = "Provides tag-expression parser for cucumber/behave";
    license = licenses.mit;
    maintainers = with maintainers; [ maxxk ];
  };
}
