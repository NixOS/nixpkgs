{ lib, buildPythonPackage, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, python
, substituteAll
, importlib-resources
, tzdata
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports-zoneinfo";
  version = "0.2.1";

  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "pganssle";
    repo = "zoneinfo";
    rev = version;
    sha256 = "sha256-00xdDOVdDanfsjQTd3yjMN2RFGel4cWRrAA3CvSnl24=";
  };

  patches = [
    (substituteAll {
      name = "zoneinfo-path";
      src = ./zoneinfo.patch;
      zoneinfo = "${tzdata}/lib/${python.libPrefix}/site-packages/tzdata/zoneinfo";
    })
  ];

  propagatedBuildInputs = [
    tzdata
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ];

  pythonImportsCheck = [ "backports.zoneinfo" ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: 'AEDT' != 'AEST'
    "test_folds_and_gaps"
    # AssertionError: 0 != 1 : (datetime.datetime(1917, 3, 25, 2, 0, 1, tzinfo=backports.zoneinfo.ZoneInfo(key='Australia/Sydney')), datetime.datetime(1917, 3, 24, 15, 0, tzinfo=datetime.timezone.utc))
    "test_folds_from_utc"
    # backports.zoneinfo._common.ZoneInfoNotFoundError: 'No time zone found with key Eurasia/Badzone'
    "test_bad_keys"
  ];

  meta = with lib; {
    description = "Backport of the standard library module zoneinfo";
    homepage = "https://github.com/pganssle/zoneinfo";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
