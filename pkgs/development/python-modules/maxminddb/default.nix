{ buildPythonPackage, lib, fetchPypi
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "1.5.4";
  pname = "maxminddb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4d28823d9ca23323d113dc7af8db2087aa4f657fafc64ff8f7a8afda871425b";
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
