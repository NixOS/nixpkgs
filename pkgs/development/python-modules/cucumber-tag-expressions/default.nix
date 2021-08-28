{ lib, fetchPypi, buildPythonPackage, pytest, pytest-html }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kb8dq458sflwl2agb2v9hp04qwygslrhdps819vq27wc44jabxw";
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
