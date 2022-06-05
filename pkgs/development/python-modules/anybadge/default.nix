{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anybadge";
  version = "1.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9C1oPZcXjrGwvkx20E+xPGje+ATD9HwOCWWn/pg+98Q=";
  };

  # setup.py reads its version from the TRAVIS_TAG environment variable
  TRAVIS_TAG = "v${version}";

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "anybadge"
  ];

  meta = with lib; {
    description = "Python tool for generating badges for your projects";
    homepage = "https://github.com/jongracecox/anybadge";
    license = licenses.mit;
    maintainers = with maintainers; [ fabiangd ];
  };
}
