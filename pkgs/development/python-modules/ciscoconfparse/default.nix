{ lib
, buildPythonPackage
, dnspython
, deprecat
, fetchFromGitHub
, loguru
, passlib
, poetry-core
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "ciscoconfparse";
  version = "1.7.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mpenning";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-oGvwtaIgVvvW8Oq/dZN+Zj/PESpqWALFYPia9yeilco=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    passlib
    deprecat
    dnspython
    loguru
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/parse_test.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_dns_lookup"
    "test_reverse_dns_lookup"
    # Path issues with configuration files
    "testParse_valid_filepath"
  ];

  pythonImportsCheck = [
    "ciscoconfparse"
  ];

  meta = with lib; {
    description = "Module to parse, audit, query, build, and modify Cisco IOS-style configurations";
    homepage = "https://github.com/mpenning/ciscoconfparse";
    changelog = "https://github.com/mpenning/ciscoconfparse/blob/${version}/CHANGES.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
