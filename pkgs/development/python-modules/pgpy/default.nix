{ lib
, pythonOlder
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, six
, enum34
, pyasn1
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pgpy";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "SecurityInnovation";
    repo = "PGPy";
    rev = "v${version}";
    hash = "sha256-iuga6vZ7eOl/wNVuLnhDVeUPJPibGm8iiyTC4dOA7A4=";
  };

  patches = [
    # Fixes the issue in https://github.com/SecurityInnovation/PGPy/issues/402.
    # by pulling in https://github.com/SecurityInnovation/PGPy/pull/403.
    (fetchpatch {
      name = "crytography-38-support.patch";
      url = "https://github.com/SecurityInnovation/PGPy/commit/d84597eb8417a482433ff51dc6b13060d4b2e686.patch";
      hash = "sha256-dviXCSGtPguROHVZ1bt/eEfpATjehm8jZ5BeVjxdb8U=";
    })
  ];

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
