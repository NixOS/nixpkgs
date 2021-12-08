{ lib, fetchFromGitHub, buildPythonPackage, pytest, pytest-html }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "4.1.0";

  src = fetchFromGitHub {
     owner = "cucumber";
     repo = "tag-expressions-python";
     rev = "v4.1.0";
     sha256 = "0iyx0mwhbikhmrhwh1i9z95igj6hsz5sa3vgxxamyy0ldzzc4s9m";
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
