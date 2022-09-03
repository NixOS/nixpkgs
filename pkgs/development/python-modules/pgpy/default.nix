{ lib, pythonOlder, fetchFromGitHub, buildPythonPackage
, six, enum34, pyasn1, cryptography
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pgpy";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "SecurityInnovation";
    repo = "PGPy";
    rev = "v${version}";
    sha256 = "03pch39y3hi4ici6y6lvz0j0zram8dw2wvnmq1zyjy3vyvm1ms4a";
  };

  propagatedBuildInputs = [
    six
    pyasn1
    cryptography
  ] ++ lib.optionals (pythonOlder "3.4") [
    enum34
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # assertions contains extra: IDEA has been deprecated
    "test_encrypt_bad_cipher"
  ];

  meta = with lib; {
    homepage = "https://github.com/SecurityInnovation/PGPy";
    description = "Pretty Good Privacy for Python 2 and 3";
    longDescription = ''
      PGPy is a Python (2 and 3) library for implementing Pretty Good Privacy
      into Python programs, conforming to the OpenPGP specification per RFC
      4880.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu dotlambda ];
  };
}
