{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pytestCheckHook
, python-dateutil
, setuptools
}:

buildPythonPackage rec {
  pname = "hologram";
  version = "0.0.16";
  format = "pyproject";

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
