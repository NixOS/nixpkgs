{ lib
, buildPythonPackage
, dnspython
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
  version = "1.6.40";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mpenning";
    repo = pname;
    rev = version;
    hash = "sha256-2j1AlCIwTxIjotZ0fSt1zhsgPfJTqJukZ6KQvh74NJ8=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    passlib
    dnspython
    loguru
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/parse_test.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_dns_lookup"
    "test_reverse_dns_lookup"
  ];

  pythonImportsCheck = [
    "ciscoconfparse"
  ];

  meta = with lib; {
    description = "Parse, Audit, Query, Build, and Modify Cisco IOS-style configurations";
    homepage = "https://github.com/mpenning/ciscoconfparse";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
