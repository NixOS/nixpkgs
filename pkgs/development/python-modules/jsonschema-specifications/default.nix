{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  referencing,
}:

buildPythonPackage rec {
  pname = "jsonschema-specifications";
  version = "2025.9.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jsonschema_specifications";
    inherit version;
    hash = "sha256-tUCYfyOedFYTx6kXbz7bcrgypKxGXPAnEiiDl4MrXo0=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    referencing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonschema_specifications" ];

  meta = {
    description = "Support files exposing JSON from the JSON Schema specifications";
    homepage = "https://github.com/python-jsonschema/jsonschema-specifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
