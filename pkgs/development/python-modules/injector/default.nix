{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "injector";
  version = "0.24.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-injector";
    repo = "injector";
    tag = version;
    hash = "sha256-Pv+3D2eyZiposXMsfhVniGNvlNGb3xSZfjIQBLMcbLA=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "injector" ];

  meta = {
    description = "Python dependency injection framework, inspired by Guice";
    homepage = "https://github.com/alecthomas/injector";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
