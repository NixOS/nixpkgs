{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyxbe";
  version = "unstable-2021-01-10";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = pname;
    rev = "a7ae1bb21b02a57783831eb080c1edbafaad1d5d";
    sha256 = "1cp9a5f41z8j7bzip6nhka8qnxs12v75cdf80sk2nzgf1k15wi2p";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Update location for run with pytest
  preCheck = ''
    substituteInPlace tests/test_load.py \
      --replace "'xbefiles'" "'tests/xbefiles'"
  '';

  pythonImportsCheck = [ "xbe" ];

  meta = with lib; {
    description = "Library to work with XBE files";
    homepage = "https://github.com/mborgerson/pyxbe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
