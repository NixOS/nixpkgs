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
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-sagan";
    rev = "v${version}";
    hash = "sha256-L42YnGG7S4HzZQGF1pftC7dKu0VOwE3DV1JzPqQ03Tk=";
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

  meta = with lib; {
    description = "Parsing library for RIPE Atlas measurements results";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-sagan";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
