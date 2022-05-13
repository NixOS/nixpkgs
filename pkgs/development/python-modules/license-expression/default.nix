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
  version = "30.0.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "v${version}";
    hash = "sha256-tGXNZm9xH8sXa7dtBFsTzGgT+hfbmkwps7breR7KUWU=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
