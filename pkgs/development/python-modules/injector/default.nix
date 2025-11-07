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
  version = "0.22.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-injector";
    repo = "injector";
    tag = version;
    hash = "sha256-FRO/stQDTa4W1f6mLPDCJslYFfIvgS0EgoEhuh0rxwA=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "injector" ];

  meta = with lib; {
    description = "Python dependency injection framework, inspired by Guice";
    homepage = "https://github.com/alecthomas/injector";
    maintainers = [ ];
    license = licenses.bsd3;
  };
}
