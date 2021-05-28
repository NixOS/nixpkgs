{ stdenv, lib, buildPythonPackage, pythonOlder, pythonAtLeast
, fetchPypi
, libmaxminddb
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "maxminddb";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b95d8ed21799e6604683669c7ed3c6a184fcd92434d5762dccdb139b4f29e597";
  };

  buildInputs = [ libmaxminddb ];

  propagatedBuildInputs = [ ipaddress ];

  checkInputs = [ nose mock ];

  # Tests are broken for macOS on python38
  doCheck = !(stdenv.isDarwin && pythonAtLeast "3.8");

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
