{
  lib,
  allure-python-commons,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "allure-pytest";
  version = "2.13.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DvjheQxEqYjba4PE1PXpFFHixMjqEGAd+ohSjSOvz24=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ allure-python-commons ];

  # Tests were moved to the meta package
  doCheck = false;

  pythonImportsCheck = [ "allure_pytest" ];

  meta = {
    description = "Allure integrations for Python test frameworks";
    homepage = "https://github.com/allure-framework/allure-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evanjs ];
  };
}
