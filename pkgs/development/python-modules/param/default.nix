{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, hatchling
, hatch-vcs

# tests
, numpy
, pandas
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "param";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8R1+utY3e3py4iJTgOVfzt5Y7bp2Rn6OfoITGuOsb5c=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    numpy
    pandas
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "param"
  ];

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = "https://param.holoviz.org/";
    changelog = "https://github.com/holoviz/param/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
