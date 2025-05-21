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
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThirVondukr";
    repo = "passlib";
    tag = version;
    hash = "sha256-Q5OEQkty0/DugRvF5LA+PaDDlF/6ysx4Nel5K2kH5s4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  nativeCheckInputs = [
    pytest-archon
    pytest-xdist
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "passlib" ];

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
