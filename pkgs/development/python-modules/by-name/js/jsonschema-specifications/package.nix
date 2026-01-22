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
  version = "2025.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jsonschema_specifications";
    inherit version;
    hash = "sha256-YwFZyfTb6hYaaiIFwwEcxPGP84Gxif/0i7Obm/Jq5gg=";
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
