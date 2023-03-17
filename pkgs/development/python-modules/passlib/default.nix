{ lib
, buildPythonPackage
, fetchPypi
, argon2_cffi
, bcrypt
, cryptography
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3v1Q9ytlxUAqssVzgwppeOXyAq0NmEeTyN3ixBUuvgQ";
  };

  passthru.extras-require = {
    argon2 = [ argon2_cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  checkInputs = [
    pytestCheckHook
  ] ++ passthru.extras-require.argon2
    ++ passthru.extras-require.bcrypt
    ++ passthru.extras-require.totp;

  pythonImportsCheck = [
    "passlib"
  ];

  disabledTests = [
    # timming sensitive
    "test_dummy_verify"
    "test_encrypt_cost_timing"
    # These tests fail because they don't expect support for algorithms provided through libxcrypt
    "test_82_crypt_support"
  ];

  meta = with lib; {
    description = "A password hashing library for Python";
    homepage = "https://foss.heptapod.net/python-libs/passlib";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
