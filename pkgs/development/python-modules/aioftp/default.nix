{ lib
, stdenv
, async-timeout
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, siosocks
, trustme
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.21.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xtrlCzqgfwlbLZOoN9Y23ZPyNaqv5Ure+Cvg+OVWf9I=";
  };

  propagatedBuildInputs = [
    siosocks
  ];

  checkInputs = [
    async-timeout
    pytest-asyncio
    pytestCheckHook
    trustme
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # uses 127.0.0.2, which macos doesn't like
    "test_pasv_connection_pasv_forced_response_address"
  ];

  pythonImportsCheck = [
    "aioftp"
  ];

  meta = with lib; {
    description = "Python FTP client/server for asyncio";
    homepage = "https://github.com/aio-libs/aioftp";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
