{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pythonAtLeast
, setuptools
}:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.17";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "ponyorm";
    repo = "pony";
    rev = "refs/tags/v${version}";
    hash = "sha256-wBqw+YHKlxYplgsYL1pbkusHyPfCaVPcH/Yku6WDYbE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests are outdated
    "test_method"
  ];

  pythonImportsCheck = [
    "pony"
  ];

  meta = with lib; {
    description = "Library for advanced object-relational mapping";
    homepage = "https://ponyorm.org/";
    changelog = "https://github.com/ponyorm/pony/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ d-goldin xvapx ];
  };
}
