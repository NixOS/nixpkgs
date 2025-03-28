{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  argon2-cffi,
  bcrypt,
  cryptography,
  hatchling,
  pytestCheckHook,
  pytest-archon,
  pytest-xdist,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThirVondukr";
    repo = "passlib";
    tag = version;
    hash = "sha256-Q5OEQkty0/DugRvF5LA+PaDDlF/6ysx4Nel5K2kH5s4=";
  };

  build-system = [ hatchling ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-archon
    pytest-xdist
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "passlib" ];

  disabledTests = [
    # timming sensitive
    "test_dummy_verify"
    "test_encrypt_cost_timing"
  ];

  meta = {
    changelog = "https://github.com/ThirVondukr/passlib/blob/${src.tag}/CHANGELOG.md";
    description = "Password hashing library for Python";
    homepage = "https://github.com/ThirVondukr/passlib";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
