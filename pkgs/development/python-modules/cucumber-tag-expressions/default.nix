{ lib, fetchPypi, buildPythonPackage, pytest, pytest-html }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ef4e0513d4c26d42299ffed010ed5e24125b87fc64de2e74b979d4a84c8f522";
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
