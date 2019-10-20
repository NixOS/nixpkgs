{ buildPythonPackage, lib, fetchPypi
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "1.5.1";
  pname = "maxminddb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y9giw81k4wdmpryr4k42w50z292mf364a6vs1vxf83ksc9ig6j4";
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
