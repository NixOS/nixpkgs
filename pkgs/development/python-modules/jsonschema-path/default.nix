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
  version = "0.3.2";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "jsonschema-path";
    rev = version;
    hash = "sha256-HC0yfACKFIQEQoIa8/FUKyV8YS8TQ0BY7i3n9xCdKz8=";
  };

  postPatch = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "referencing" ];

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
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-path";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
