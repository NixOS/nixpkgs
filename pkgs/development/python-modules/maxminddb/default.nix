{ stdenv, lib, buildPythonPackage, pythonOlder, pythonAtLeast
, fetchPypi
, libmaxminddb
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "maxminddb";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e37707ec4fab115804670e0fb7aedb4b57075a8b6f80052bdc648d3c005184e5";
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
