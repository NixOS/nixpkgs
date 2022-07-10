{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "result";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rustedpy";
    repo = "result";
     rev = "v${version}";
    sha256 = "sha256-bEf3OJg6ksDvzZE7ezA58Q2FObb5V7BG8vkKtX284Jg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"--flake8",' "" \
      --replace '"--tb=short",' "" \
      --replace '"--cov=result",' "" \
      --replace '"--cov=tests",' "" \
      --replace '"--cov-report=term",' "" \
      --replace '"--cov-report=xml",' ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    #TODO: figure out the failure "match o:" Invalid Syntax
    "tests/test_pattern_matching.py"
  ];

  pythonImportsCheck = [ "result" ];

  meta = with lib; {
    description = "A simple Result type for Python 3 inspired by Rust, fully type annotated";
    homepage = "https://github.com/rustedpy/result";
    license = licenses.mit;
    maintainers = [];
  };
}
