{ lib
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ratelimiter";
  version = "1.2.0.post0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XDldyr273i5ReO8/ibVoowZkVKbdwiO3ZHPawi+JtPc=";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ratelimiter"
  ];

  preCheck = ''
    # Uses out-dated options
    rm tests/conftest.py
  '';

  disabledTests = [
    # TypeError: object Lock can't be used in 'await' expression
    "test_alock"
  ];

  meta = with lib; {
    description = "Simple python rate limiting object";
    homepage = "https://github.com/RazerM/ratelimiter";
    license = licenses.asl20;
    maintainers = with maintainers; [ helkafen ];
  };
}
