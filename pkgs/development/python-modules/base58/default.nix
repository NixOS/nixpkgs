{ lib
, buildPythonPackage
, fetchPypi
, pyhamcrest
, pytest-benchmark
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "base58";
  version = "2.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FxpUe0o8YeGuOAciSm967HXjZMQ5XnViZJ1zNXaAAaI=";
  };

  checkInputs = [
    pyhamcrest
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "base58" ];

  meta = with lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
