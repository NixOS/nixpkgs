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
  version = "6.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "tag-expressions";
    tag = "v${version}";
    hash = "sha256-ptDsN6loFXrKT1xeR138kXzA5TbHPH1G7I/25ZD8Nj4=";
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
