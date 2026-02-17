{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pytest-html,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "tag-expressions";
    tag = "v${version}";
    hash = "sha256-U8x7c4NeP9GdwormQD79RWcAA2B39Yvrf/Zk0xTUtNA=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-html
    pyyaml
  ];

  meta = {
    homepage = "https://github.com/cucumber/tag-expressions";
    description = "Provides tag-expression parser for cucumber/behave";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxxk ];
  };
}
