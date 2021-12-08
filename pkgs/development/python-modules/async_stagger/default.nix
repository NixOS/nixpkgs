{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "twisteroidambassador";
     repo = "async_stagger";
     rev = "v0.3.1";
     sha256 = "0971ah19z9n52xhbylssh5nmdays9rmxhg3hjy0iv8bnfykz62xc";
  };

  checkInputs = [
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
