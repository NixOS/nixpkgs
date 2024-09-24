{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  python,
  substituteAll,
  importlib-resources,
  tzdata,
  hypothesis,
  pytestCheckHook,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "backports-zoneinfo";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "pganssle";
    repo = "zoneinfo";
    rev = version;
    hash = "sha256-00xdDOVdDanfsjQTd3yjMN2RFGel4cWRrAA3CvSnl24=";
  };

  # Make sure test data update patch applies
  prePatch = ''
    substituteInPlace tests/data/zoneinfo_data.json --replace \"2020a\" \"2021a\"
  '';

  patches = [
    # Update test suite's test data to zoneinfo 2022a
    # https://github.com/pganssle/zoneinfo/pull/115
    (fetchpatch {
      name = "backports-zoneinfo-2022a-update-test-data1.patch";
      url = "https://github.com/pganssle/zoneinfo/pull/115/commits/837e2a0f9f1a1332e4233f83e3648fa564a9ec9e.patch";
      sha256 = "196knwa212mr0b7zsh8papzr3f5mii87gcjjjx1r9zzvmk3g3ri0";
    })
    (fetchpatch {
      name = "backports-zoneinfo-2022a-update-test-data2.patch";
      url = "https://github.com/pganssle/zoneinfo/pull/115/commits/9fd330265b177916d6182249439bb40d5691eb58.patch";
      sha256 = "1zxa5bkwi8hbnh4c0qv72wv6vdp5jlxqizfjsc05ymzvwa99cf75";
    })

    (substituteAll {
      name = "zoneinfo-path";
      src = ./zoneinfo.patch;
      zoneinfo = "${tzdata}/${python.sitePackages}/tzdata/zoneinfo";
    })
  ];

  propagatedBuildInputs = [ tzdata ] ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  pythonImportsCheck = [ "backports.zoneinfo" ];

  nativeCheckInputs = [
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
    maintainers = [ ];
  };
}
