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
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "objsize";
    tag = version;
    hash = "sha256-l0l80dMVWZqWBK4z53NCU+rKOQl6jRZ1zb2SmMnhs1k=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "objsize" ];

  enabledTestPaths = [ "test_objsize.py" ];

  meta = with lib; {
    description = "Traversal over objects subtree and calculate the total size";
    homepage = "https://github.com/liran-funaro/objsize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ocfox ];
  };
}
