{ lib
, buildPythonPackage
, fetchPypi
, argon2-cffi
, bcrypt
, cryptography
, pytestCheckHook
, pythonOlder
, pytest-xdist
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

  passthru.optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ passthru.optional-dependencies.argon2
  ++ passthru.optional-dependencies.bcrypt
  ++ passthru.optional-dependencies.totp;

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

  pytestFlagsArray = [
    # hashing algorithms we don't support anymore
    "--deselect=passlib/tests/test_handlers.py::des_crypt_os_crypt_test::test_82_crypt_support"
    "--deselect=passlib/tests/test_handlers.py::md5_crypt_os_crypt_test::test_82_crypt_support"
    "--deselect=passlib/tests/test_handlers.py::sha256_crypt_os_crypt_test::test_82_crypt_support"
  ];

  meta = with lib; {
    description = "A password hashing library for Python";
    homepage = "https://foss.heptapod.net/python-libs/passlib";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
