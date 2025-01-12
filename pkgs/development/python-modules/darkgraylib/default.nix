{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  toml,
  pygments,
  pytestCheckHook,
  pytest-kwparametrize,
  gitMinimal,
}:

buildPythonPackage rec {
  pname = "darkgraylib";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "darkgraylib";
    rev = "refs/tags/v${version}";
    hash = "sha256-095k+ExvOMfGQdoVEI4EnAvFWzw81wYsBO9ATYH/V8E=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    toml
  ];

  optional-dependencies = {
    color = [ pygments ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-kwparametrize
    gitMinimal
  ] ++ optional-dependencies.color;

  disabledTestPaths = [
    "src/darkgraylib/*.py"
    "src/darkgraylib/highlighting/*.py"
    "src/darkgraylib/testtools/*.py"
  ];

  pythonImportsCheck = [ "darkgraylib" ];

  meta = {
    changelog = "https://github.com/akaihola/darkgraylib/releases/tag/v${version}";
    description = "Common supporting code for Darker and Graylint";
    homepage = "https://github.com/akaihola/darkgraylib";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
