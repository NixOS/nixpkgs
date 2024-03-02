{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pexpect
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.2.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vnzZdJ7pZz1QxlTqw5UKjxB4GVcXuCfKWX4lu3ORWas=";
  };

  nativeBuildInputs = [
    cython
  ];

  nativeCheckInputs = [
    pexpect
  ];

  checkPhase = ''
    ${python.interpreter} tests/cPyparsing_test.py
  '';

  pythonImportsCheck = [
    "cPyparsing"
  ];

  meta = with lib; {
    description = "Cython PyParsing implementation";
    homepage = "https://github.com/evhub/cpyparsing";
    changelog = "https://github.com/evhub/cpyparsing/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
