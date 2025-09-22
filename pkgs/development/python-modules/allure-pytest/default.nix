{
  lib,
  allure-python-commons,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "allure-pytest";
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allure-framework";
    repo = "allure-python";
    tag = version;
    hash = "sha256-I3Zh9frOplcPqLd8b4peNM9WtbNmQjHX6ocVJJwPzyc=";
  };

  sourceRoot = "${src.name}/allure-pytest";

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [ allure-python-commons ];

  # Tests were moved to the meta package
  doCheck = false;

  pythonImportsCheck = [ "allure_pytest" ];

  meta = with lib; {
    description = "Allure integrations for Python test frameworks";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
