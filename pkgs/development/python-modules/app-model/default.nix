{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, in-n-out
, psygnal
, pydantic
, pydantic-compat
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "app-model";
  version = "0.2.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "app-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-EMlxY9Xna9e3kWJ7X8oRuLHEmivwVFcEXRDvZfN2rNY=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    psygnal
    pydantic
    pydantic-compat
    in-n-out
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "app_model"
  ];

  meta = with lib; {
    description = "Module to implement generic application schema";
    homepage = "https://github.com/pyapp-kit/app-model";
    changelog = "https://github.com/pyapp-kit/app-model/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
