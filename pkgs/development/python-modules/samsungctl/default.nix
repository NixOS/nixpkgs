{ lib
, buildPythonPackage
, fetchPypi

# extra: websocket
, websocket-client
}:

buildPythonPackage rec {
  pname = "samsungctl";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ipz3fd65rqkxlb02sql0awc3vnslrwb2pfrsnpfnf8bfgxpbh9g";
  };

  passthru.optional-dependencies = {
    websocket = [
      websocket-client
    ];
    # interactive_ui requires curses package
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "samsungctl" ];

  meta = with lib; {
    description = "Remote control Samsung televisions via a TCP/IP connection";
    homepage = "https://github.com/Ape/samsungctl";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
