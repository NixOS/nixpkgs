{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pathable,
  pyyaml,
  referencing,
  pytest-cov-stub,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "jsonschema-path";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "jsonschema-path";
    tag = version;
    hash = "sha256-rCepDnVAOEsokKjWCuqDYbGIq6/wn4rsQRx5dXTUsYo=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "referencing" ];

  propagatedBuildInputs = [
    pathable
    pyyaml
    referencing
  ];

  pythonImportsCheck = [ "jsonschema_path" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    responses
  ];

  meta = {
    changelog = "https://github.com/p1c2u/jsonschema-path/releases/tag/${version}";
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-path";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
