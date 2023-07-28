{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, jsonschema
, pytestCheckHook
, python-dateutil
, setuptools
}:

buildPythonPackage rec {
  pname = "hologram";
  version = "0.0.16";
  format = "pyproject";

  # ValueError: mutable default <class 'tests.conftest.Point'> for field a is not allowed: use default_factory
  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DboVCvByI8bTThamGBwSiQADGxIaEnTMmwmVI+4ARgc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jsonschema
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hologram"
  ];

  meta = with lib; {
    description = "A library for automatically generating Draft 7 JSON Schemas from Python dataclasses";
    homepage = "https://github.com/dbt-labs/hologram";
    license = licenses.mit;
    maintainers = with maintainers; [ mausch tjni ];
  };
}
