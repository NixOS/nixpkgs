{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pytest-html
, pyyaml
, setuptools
 }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub{
    owner = "cucumber";
    repo = "tag-expressions";
    rev = "refs/tags/v${version}";
    hash = "sha256-etJKAOamCq63HsUqJMPBnmn0YFO3ZHOvs3/rDHN7YPU=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    setuptools
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
