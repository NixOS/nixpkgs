{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "objsize";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "objsize";
    rev = "refs/tags/${version}";
    hash = "sha256-wy4Tj+Q+4zymRdoN8Z7wcazJTb2lQ+XHY1Kta02R3R0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "objsize" ];

  pytestFlagsArray = [ "test_objsize.py" ];

  meta = with lib; {
    description = "Traversal over objects subtree and calculate the total size";
    homepage = "https://github.com/liran-funaro/objsize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ocfox ];
  };
}
