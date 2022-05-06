{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyxbe";
  version = "0.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mHUmSSy/ygteJhRX6AbgZJ+c5MZMZcgNRoTOfxhV+XQ=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Update location for run with pytest
  preCheck = ''
    substituteInPlace tests/test_load.py \
      --replace "'xbefiles'" "'tests/xbefiles'"
  '';

  pythonImportsCheck = [
    "xbe"
  ];

  meta = with lib; {
    description = "Library to work with XBE files";
    homepage = "https://github.com/mborgerson/pyxbe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
