{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyxbe";
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iLzGGgizUbaEG1xrNq4WDaWrGtcaLwAYgn4NGYiSDBo=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Update location for run with pytest
  preCheck = ''
    substituteInPlace tests/test_load.py \
      --replace '"xbefiles"' '"tests/xbefiles"'
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
