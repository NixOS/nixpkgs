{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  behave,
  allure-python-commons,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "allure-behave";
  version = "2.15.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allure-framework";
    repo = "allure-python";
    tag = version;
    hash = "sha256-06SKodvyoT0mYn4RmAIryZc+VyTI79KXFK+2/zuhzQ0=";
  };

  sourceRoot = "${src.name}/allure-behave";

  build-system = [ setuptools-scm ];

  dependencies = [
    allure-python-commons
    behave
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "allure_behave" ];

  meta = {
    description = "Allure behave integration";
    homepage = "https://github.com/allure-framework/allure-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
