{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  simpleeval,
  wcmatch,
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "1.41.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "casbin";
    repo = "pycasbin";
    tag = "v${version}";
    hash = "sha256-axW09wU/xywVui1fZKoTTIeHL0ooV1KsMhynqxiy2dI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    simpleeval
    wcmatch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "casbin" ];

  meta = with lib; {
    description = "Authorization library that supports access control models like ACL, RBAC and ABAC";
    homepage = "https://github.com/casbin/pycasbin";
    changelog = "https://github.com/casbin/pycasbin/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
