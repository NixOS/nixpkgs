{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

# dependencies
, flask
, jsonschema
, mistune
, pyyaml
, six
, werkzeug

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flasgger";
  version = "0.9.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "flasgger";
    repo = "flasgger";
    rev = version;
    hash = "sha256-cYFMKZxpi69gVWqyZUltCL0ZwcfIABNsJKqAhN2TTSg=";
  };

  patches = [
    (fetchpatch {
      # flask 2.3 compat
      url = "https://github.com/flasgger/flasgger/commit/ab77be7c6de1d4b361f0eacfa37290239963f890.patch";
      hash = "sha256-ZbE5pPUP23nZAP/qcdeWkwzrZgqJSRES7oFta8U1uVQ=";
    })
  ];

  propagatedBuildInputs = [
    flask
    jsonschema
    mistune
    pyyaml
    six
    werkzeug
  ];

  pythonImportsCheck = [
    "flasgger"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false; # missing flex dependency

  meta = with lib; {
    description = "Easy OpenAPI specs and Swagger UI for your Flask API";
    homepage = "https://github.com/flasgger/flasgger/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
