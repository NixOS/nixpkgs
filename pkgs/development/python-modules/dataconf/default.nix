{
  lib,
  buildPythonPackage,
  fetchPypi,
  isodate,
  poetry-core,
  pyhocon,
  pyparsing,
  python-dateutil,
  pyyaml,
}:
let
  pname = "dataconf";
  version = "3.6.0";
in
buildPythonPackage {
  inherit pname version;

  pyproject = true;

  dependencies = [
    isodate
    pyhocon
    pyparsing
    python-dateutil
    pyyaml
  ];

  build-system = [ poetry-core ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hcZi8n290GZkgIM074Z1Ne2gOS5WDmX8fPR+BJGZyzU=";
  };

  pythonImportsCheck = [ "dataconf" ];

  meta = {
    description = "Simple dataclasses configuration management for Python with hocon/json/yaml/properties/env-vars/dict/cli support";
    changelog = "https://github.com/zifeo/dataconf/blob/main/CHANGELOG.md";
    homepage = "https://github.com/zifeo/dataconf";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.Nebucatnetzer ];
  };
}
