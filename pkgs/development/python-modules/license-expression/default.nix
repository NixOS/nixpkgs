{ lib
, boolean-py
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "30.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "refs/tags/v${version}";
    hash = "sha256-QPjVSSndgKlAdGY6nZjjOrnyyVfOVu8ggfBwGWi+RyE=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    boolean-py
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "license_expression"
  ];

  meta = with lib; {
    description = "Utility library to parse, normalize and compare License expressions";
    homepage = "https://github.com/nexB/license-expression";
    changelog = "https://github.com/nexB/license-expression/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
