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
  version = "21.6.14";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "v${version}";
    sha256 = "sha256-hwfYKKalo8WYFwPCsRRXNz+/F8/42PXA8jxbIQjJH/g=";
  };

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

  pythonImportsCheck = [ "license_expression" ];

  meta = with lib; {
    description = "Utility library to parse, normalize and compare License expressions for Python";
    homepage = "https://github.com/nexB/license-expression";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
