{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, pytestCheckHook
, pytest-asyncio
, pytest-mock
}:

buildPythonPackage rec {
  pname = "async_stagger";
  version = "0.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "007l54fbk2dfzv3vmqz98m1i37mzxkkva5r4fiwq2pg8nb61fy0w";
  };

  patches = [
    (fetchpatch {
      # Fix test failures on Python 3.8
      # https://github.com/twisteroidambassador/async_stagger/issues/4
      url = "https://github.com/twisteroidambassador/async_stagger/commit/736ab20ff9c172628d911f1e6f72420399ec9631.patch";
      sha256 = "1ygqd9n56sj83lvgmv6nrx3m0sp3646s5k7z697qx43xslixj731";
    })
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "async_stagger" ];

  meta = with lib; {
    description = "Happy Eyeballs connection algorithm and underlying scheduling logic in asyncio";
    homepage = "https://github.com/twisteroidambassador/async_stagger";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
