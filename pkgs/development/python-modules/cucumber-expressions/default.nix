{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "cucumber-expressions";
  version = "18.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "cucumber-expressions";
    tag = "v${version}";
    hash = "sha256-Mbf7bG7NvKFdv6kYPkd6UlPDJGjnK2GPl0qnLUhQ3es=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "cucumber_expressions" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = {
    changelog = "https://github.com/cucumber/cucumber-expressions/blob/${src.tag}/CHANGELOG.md";
    description = "Human friendly alternative to Regular Expressions";
    homepage = "https://github.com/cucumber/cucumber-expressions/tree/main/python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
