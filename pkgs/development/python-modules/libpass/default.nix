{
  argon2-cffi,
  bcrypt,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  lib,
  pytest-archon,
  pytest-xdist,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "libpass";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThirVondukr";
    repo = "passlib";
    tag = version;
    hash = "sha256-fzI9HpGE3wNK41ZSOeA5NAr5T4r3Jzdqe5+SHoWVXUs=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  nativeCheckInputs = [
    pytest-archon
    pytest-xdist
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "passlib" ];

  disabledTestPaths = [
    # https://github.com/notypecheck/passlib/issues/18
    "tests/test_handlers_bcrypt.py::bcrypt_bcrypt_test::test_70_hashes"
    "tests/test_handlers_bcrypt.py::bcrypt_bcrypt_test::test_77_fuzz_input"
    "tests/test_handlers_django.py::django_bcrypt_test::test_77_fuzz_input"
    "tests/test_handlers_bcrypt.py::bcrypt_bcrypt_test::test_secret_w_truncate_size"
    "tests/test_handlers_django.py::django_bcrypt_test::test_secret_w_truncate_size"
  ];

  disabledTests = [
    # timming sensitive
    "test_dummy_verify"
    "test_encrypt_cost_timing"
  ];

  meta = {
    changelog = "https://github.com/ThirVondukr/passlib/blob/${src.tag}/CHANGELOG.md";
    description = "Comprehensive password hashing framework supporting over 30 schemes";
    homepage = "https://github.com/ThirVondukr/passlib";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
