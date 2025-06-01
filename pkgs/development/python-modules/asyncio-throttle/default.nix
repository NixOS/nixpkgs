{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "asyncio-throttle";
  version = "1.0.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hallazzang";
    repo = "asyncio-throttle";
    rev = "v${version}";
    sha256 = "1hsjcymdcm0hf4l68scf9n8j7ba89azgh96xhxrnyvwxfs5acnmv";
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asyncio_throttle" ];

  meta = with lib; {
    description = "Simple, easy-to-use throttler for asyncio";
    homepage = "https://github.com/hallazzang/asyncio-throttle";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
