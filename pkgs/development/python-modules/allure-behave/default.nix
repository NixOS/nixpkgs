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
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allure-framework";
    repo = "allure-python";
    tag = version;
    hash = "sha256-IwkbrOEhPuScn/eTDevbgV3w/awPivvSauD1tmAH7Qk=";
  };

  sourceRoot = "${src.name}/allure-behave";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm<10" "setuptools_scm"
  '';

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
