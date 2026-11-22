{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-regex-commit,
  pytestCheckHook,
  pytest-cov-stub,
  argon2-cffi,
  bcrypt,
}:

buildPythonPackage rec {
  pname = "pwdlib";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "pwdlib";
    tag = "v${version}";
    hash = "sha256-4fqdgeDtPZztaR2SzwpYjv3WjXcf/9qHKzNwm/muXm8=";
  };

  build-system = [
    hatchling
    hatch-regex-commit
  ];

  dependencies = [
    argon2-cffi
    bcrypt
  ];

  pythonImportsCheck = [ "pwdlib" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Modern password hashing for Python";
    changelog = "https://github.com/frankie567/pwdlib/releases/tag/v${version}";
    homepage = "https://github.com/frankie567/pwdlib";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
