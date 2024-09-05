{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rajlaud";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-d+8/YyA6tTBxZpiR9pu/5K1v0FOiSrR7RZ7MMBwOzdA=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysqueezebox" ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # AttributeError: 'has_calls' is not a valid assertion. Use a spec for the mock if 'has_calls' is meant to be an attribute.
    "test_verified_pause"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_integration.py"
  ];

  meta = with lib; {
    description = "Asynchronous library to control Logitech Media Server";
    homepage = "https://github.com/rajlaud/pysqueezebox";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
