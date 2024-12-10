{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  argon2-cffi,
  bcrypt,
  cryptography,
  pytestCheckHook,
  pythonOlder,
  pytest-xdist,
  setuptools,
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.7.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "python-libs";
    repo = "passlib";
    rev = "refs/tags/${version}";
    hash = "sha256-Mx2Xg/KAEfvfep2B/gWATTiAPJc+f22MTcsEdRpt3n8=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

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

  nativeCheckInputs =
    [
      pytestCheckHook
      pytest-xdist
    ]
    ++ optional-dependencies.argon2
    ++ optional-dependencies.bcrypt
    ++ optional-dependencies.totp;

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

  meta = {
    changelog = "https://foss.heptapod.net/python-libs/passlib/-/blob/${version}/docs/history/${lib.versions.majorMinor version}.rst";
    description = "Password hashing library for Python";
    homepage = "https://foss.heptapod.net/python-libs/passlib";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
