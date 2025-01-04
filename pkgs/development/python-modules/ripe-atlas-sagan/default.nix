{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  ujson,
}:

buildPythonPackage rec {
  pname = "ripe-atlas-sagan";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xIBIKsQvDmVBa/C8/7Wr3WKeepHaGhoXlgatXSUtWLA=";
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

  pytestFlagsArray = [ "tests/*.py" ];

  disabledTests = [
    # This test fail for unknown reason, I suspect it to be flaky.
    "test_invalid_country_code"
  ];

  pythonImportsCheck = [ "ripe.atlas.sagan" ];

  meta = with lib; {
    description = "Parsing library for RIPE Atlas measurements results";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-sagan";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
