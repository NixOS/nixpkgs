{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
, types-setuptools
}:

buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "requirements-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-fUx6NBD6qxAyArGgCiB2J1Ak7pudx/LI0+rCHjLnc1M=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    setuptools
    types-setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "requirements"
  ];

  meta = with lib; {
    description = "Pip requirements file parser";
    homepage = "https://github.com/davidfischer/requirements-parser";
    changelog = "https://github.com/madpah/requirements-parser/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
