{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyhamcrest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "base58";
  version = "2.1.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5d0cb3f5b6e81e8e35da5754388ddcc6d0d14b6c6a132cb93d69ed580a7278c";
  };

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
  ];

  disabledTests = [
    # avoid dependency on pytest-benchmark
    "test_decode_random"
    "test_encode_random"
  ];

  pythonImportsCheck = [ "base58" ];

  meta = with lib; {
    description = "Base58 and Base58Check implementation";
    mainProgram = "base58";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
