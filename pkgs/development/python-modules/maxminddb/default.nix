{ buildPythonPackage, lib, fetchPypi
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "1.4.1";
  pname = "maxminddb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04mpilsj76m29id5xfi8mmasdmh27ldn7r0dmh2rj6a8v2y5256z";
  };

  propagatedBuildInputs = [ ipaddress ];

  checkInputs = [ nose mock ];

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.apsl20;
    maintainers = with maintainers; [ ];
  };
}
