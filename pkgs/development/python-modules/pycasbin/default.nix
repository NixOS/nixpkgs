{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  simpleeval,
  wcmatch,
}:

buildPythonPackage rec {
  pname = "pycasbin";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "casbin";
    repo = "pycasbin";
    tag = "v${version}";
    hash = "sha256-UYl+n0quHOfC0lTAdLi7EbrvwcGa8Gzh+1ofc38rPx8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    simpleeval
    wcmatch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "casbin" ];

  meta = {
    description = "Authorization library that supports access control models like ACL, RBAC and ABAC";
    homepage = "https://github.com/casbin/pycasbin";
    changelog = "https://github.com/casbin/pycasbin/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
