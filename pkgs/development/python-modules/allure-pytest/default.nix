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
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allure-framework";
    repo = "allure-python";
    tag = version;
    hash = "sha256-IwkbrOEhPuScn/eTDevbgV3w/awPivvSauD1tmAH7Qk=";
  };

  sourceRoot = "${src.name}/allure-pytest";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm<10" "setuptools_scm"
  '';

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [ allure-python-commons ];

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
