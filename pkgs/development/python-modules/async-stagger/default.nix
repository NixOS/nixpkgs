{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "async-stagger";
  version = "0.4.0.post1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "async_stagger";
    inherit version;
    hash = "sha256-s3jI25FbKFH7sf0KiaXIsheLnNYvMXHEc+R6f0PLrFw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  disabledTests = [
    # RuntimeError: Logic bug in...
    "test_stagger_coro_gen"
  ];

  pythonImportsCheck = [ "async_stagger" ];

  meta = with lib; {
    description = "Happy Eyeballs connection algorithm and underlying scheduling logic in asyncio";
    homepage = "https://github.com/twisteroidambassador/async_stagger";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
