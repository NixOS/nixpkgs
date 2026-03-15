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

let
  inherit (lib.versions) major minor patch;
  inherit (lib.strings) concatStringsSep replicate;
  inherit (builtins) stringLength;

  pad = char: length: input:
    (replicate (lib.max 0 (length - stringLength input)) char) + input;

  toCalVer = version:
    concatStringsSep "." [
      (major version)
      (pad "0" 2 (minor version))
      (patch version)
    ];

in
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
    # The version here must be converted as release tags on PyPI and GitHub have different zero-padding
    changelog = "https://github.com/mdomke/schwifty/blob/${toCalVer version}/CHANGELOG.rst";
    description = "Validate/generate IBANs and BICs";
    homepage = "https://github.com/mdomke/schwifty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milibopp ];
  };
}
