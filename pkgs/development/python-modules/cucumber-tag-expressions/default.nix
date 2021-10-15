{ lib, fetchPypi, buildPythonPackage, pytest, pytest-html }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e314d5fed6eebb2f90380271f562248fb15e18636764faf40f4dde4b28b1f960";
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
