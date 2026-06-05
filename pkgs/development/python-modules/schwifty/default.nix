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
  version = "2026.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VhZBQDAewy23iyMfli9Xsf1zIAKO6Q38OWNEOW9pdJg=";
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
