{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, pytest-asyncio
, pytest-mock
}:

buildPythonPackage rec {
  pname = "async_stagger";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mj3daaqxjdavbxcjrdwx5ky9maa2blbv53aa6d7w9zxkrz3b7xa";
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

  pythonImportsCheck = [
    "async_stagger"
  ];

  meta = with lib; {
    description = "Happy Eyeballs connection algorithm and underlying scheduling logic in asyncio";
    homepage = "https://github.com/twisteroidambassador/async_stagger";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
