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
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "tag-expressions";
    tag = "v${version}";
    hash = "sha256-m6CmRs/Fz2e9GTtHrE3FF8GPK2vs6i37xcI3BM64rlc=";
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

  meta = with lib; {
    homepage = "https://github.com/cucumber/tag-expressions";
    description = "Provides tag-expression parser for cucumber/behave";
    license = licenses.mit;
    maintainers = with maintainers; [ maxxk ];
  };
}
