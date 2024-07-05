{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "iptools";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bd808";
    repo = "python-iptools";
    rev = "refs/tags/v${version}";
    hash = "sha256-340Wc4QGwUqEEANM5EQzFaXxIWVf2fDr4qfCuxNEVBQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "iptools" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/iptools/iptools_test.py" ];

  meta = with lib; {
    description = "Utilities for manipulating IP addresses including a class that can be used to include CIDR network blocks in Django's INTERNAL_IPS setting";
    homepage = "https://github.com/bd808/python-iptools";
    license = licenses.bsd0;
  };
}
