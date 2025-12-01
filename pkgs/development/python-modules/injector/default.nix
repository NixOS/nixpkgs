{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "injector";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-injector";
    repo = "injector";
    tag = version;
    hash = "sha256-wF5gn6JdRatZkkxCLExVNRMPxQuaAZiWcEAfECKto2U=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "injector" ];

  meta = with lib; {
    description = "Python dependency injection framework";
    homepage = "https://github.com/alecthomas/injector";
    changelog = "https://github.com/python-injector/injector/blob/${src.tag}/CHANGES";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
