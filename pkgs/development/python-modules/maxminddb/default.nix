{ buildPythonPackage, lib, fetchPypi
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "maxminddb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0ce131d901eb11669996b49a59f410efd3da2c6dbe2c0094fe2fef8d85b6336";
  };

  propagatedBuildInputs = [ ipaddress ];

  checkInputs = [ nose mock ];

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
