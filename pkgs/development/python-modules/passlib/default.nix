{
  lib,
  buildPythonPackage,
  fetchPypi,
  argon2-cffi,
  bcrypt,
  cryptography,
  pytestCheckHook,
  pythonOlder,
  pytest-xdist,
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

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  # Fix for https://foss.heptapod.net/python-libs/passlib/-/issues/190
  postPatch = ''
    substituteInPlace passlib/handlers/bcrypt.py \
      --replace-fail "version = _bcrypt.__about__.__version__" \
      "version = getattr(getattr(_bcrypt, '__about__', _bcrypt), '__version__', '<unknown>')"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ optional-dependencies.argon2 ++ optional-dependencies.bcrypt ++ optional-dependencies.totp;

  pythonImportsCheck = [ "passlib" ];

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
    description = "Password hashing library for Python";
    homepage = "https://foss.heptapod.net/python-libs/passlib";
    license = licenses.bsdOriginal;
    maintainers = [ ];
  };
}
