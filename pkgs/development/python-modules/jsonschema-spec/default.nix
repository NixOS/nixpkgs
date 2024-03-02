{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook

# build
, poetry-core

# propagates
, pathable
, pyyaml
, referencing
, requests

# tests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "jsonschema-spec";
  version = "0.2.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1Flb3XQCGhrAYzTvriSVhHDb/Z/uvCyZdbav2u7f3sg=";
  };

  postPatch = ''
    sed -i "/^--cov/d" pyproject.toml

    substituteInPlace pyproject.toml \
      --replace 'referencing = ">=0.28.0,<0.30.0"' 'referencing = ">=0.28.0"'
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "referencing"
  ];

  propagatedBuildInputs = [
    pathable
    pyyaml
    referencing
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  meta = with lib; {
    changelog = "https://github.com/p1c2u/jsonschema-spec/releases/tag/${version}";
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-spec";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
