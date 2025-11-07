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
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allure-framework";
    repo = "allure-python";
    tag = version;
    hash = "sha256-I3Zh9frOplcPqLd8b4peNM9WtbNmQjHX6ocVJJwPzyc=";
  };

  sourceRoot = "${src.name}/allure-behave";

  build-system = [ setuptools-scm ];

  dependencies = [
    allure-python-commons
    behave
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "allure_behave" ];

  meta = with lib; {
    description = "Allure behave integration";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
