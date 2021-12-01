{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anybadge";
  version = "1.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xKHIoV/8qsNMcU5fd92Jjh7d7jTeYN5xakMEjR6qPX8=";
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
