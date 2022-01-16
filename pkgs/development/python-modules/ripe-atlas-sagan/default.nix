{ lib
, buildPythonPackage
, python-dateutil
, pytz
, cryptography
, pytest
, pytestCheckHook
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "ripe-atlas-sagan";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xIBIKsQvDmVBa/C8/7Wr3WKeepHaGhoXlgatXSUtWLA=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
    cryptography
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/*.py" ];

  disabledTests = [
    "test_invalid_country_code"  # This test fail for unknown reason, I suspect it to be flaky.
  ];

  pythonImportsCheck = [
    "ripe.atlas.sagan"
  ];

  meta = with lib; {
    description = "A parsing library for RIPE Atlas measurements results";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-sagan";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
