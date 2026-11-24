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

buildPythonPackage (finalAttrs: {
  pname = "passlib";
  version = "1.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notypecheck";
    repo = "passlib";
    tag = finalAttrs.version;
    hash = "sha256-ALXjKFnejhopHI3I3MOk9o5NNLeP3KI2sJVgKa5R9zs=";
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "passlib" ];

  disabledTests = [
    # timing sensitive
    "test_dummy_verify"
    "test_encrypt_cost_timing"
  ];

  meta = {
    changelog = "https://github.com/notypecheck/passlib/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Comprehensive password hashing framework supporting over 30 schemes";
    homepage = "https://github.com/notypecheck/passlib";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
