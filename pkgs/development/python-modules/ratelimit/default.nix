{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "ratelimit";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tomasbasham";
    repo = "ratelimit";
    rev = "v${version}";
    hash = "sha256-wkZwOhTe6aJGK9FzMmOBEyG5PgoSdQq+Zrj1AiEcHhI=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "ratelimit" ];

  meta = {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/tomasbasham/ratelimit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
