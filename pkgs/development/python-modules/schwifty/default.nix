{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  importlib-resources,
  iso3166,
  pycountry,
  rstr,

  # optional-dependencies
  pydantic,

  # tests
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "schwifty";
  version = "2026.07.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname;
    # The version is different missing leading zeros in the CalVer month.
    # This is due to PyPI's normalization of integers
    version = "2026.7.1";
    hash = "sha256-Rux0m5MQG5aBrEiQAEjalxdbabYWAU33qFSuN+rddEA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    iso3166
    pycountry
    rstr
  ]
  ++ lib.optionals (pythonOlder "3.12") [ importlib-resources ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "schwifty" ];

  meta = {
    changelog = "https://github.com/mdomke/schwifty/blob/${version}/CHANGELOG.rst";
    description = "Validate/generate IBANs and BICs";
    homepage = "https://github.com/mdomke/schwifty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milibopp ];
  };
}
