{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage rec {
  version = "0.8.2";
  pname = "javaproperties";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-8Deo6icInp7QpTqa+Ou6l36/23skxKOYRef2GbumDqo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    python-dateutil
    pytestCheckHook
  ];

  disabledTests = [ "time" ];

  disabledTestPaths = [ "test/test_propclass.py" ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
