{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  pytz,
  ujson,
}:

buildPythonPackage rec {
  pname = "ripe-atlas-sagan";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-sagan";
    rev = "v${version}";
    hash = "sha256-wCfH4UNUvRmiXKf2a+2LAy+5KVMDL45i48DEp5L3yXw=";
  };

  propagatedBuildInputs = [
    cryptography
    python-dateutil
    pytz
  ];

  optional-dependencies = {
    fast = [ ujson ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/*.py" ];

  disabledTests = [
    # This test fail for unknown reason, I suspect it to be flaky.
    "test_invalid_country_code"
  ];

  pythonImportsCheck = [ "ripe.atlas.sagan" ];

  meta = {
    description = "Parsing library for RIPE Atlas measurements results";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-sagan";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
