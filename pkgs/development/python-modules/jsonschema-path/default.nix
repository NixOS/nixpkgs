{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pathable,
  pyyaml,
  referencing,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "jsonschema-path";
  version = "0.3.3";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "jsonschema-path";
    rev = "refs/tags/${version}";
    hash = "sha256-oBzB6Ke19QDcMQm4MpnaS132/prrtnCekAXuPMloZx4=";
  };

  postPatch = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    pathable
    pyyaml
    referencing
  ];

  pythonImportsCheck = [ "jsonschema_path" ];

  nativeCheckInputs = [
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
