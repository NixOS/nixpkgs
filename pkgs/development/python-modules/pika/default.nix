{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, nose
, mock
, twisted
, tornado
}:

buildPythonPackage rec {
  pname = "pika";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pika";
    repo = "pika";
    rev = version;
    sha256 = "sha256-Wog6Wxa8V/zv/bBrFOigZi6KE5qRf82bf1GK2XwvpDI=";
  };

  propagatedBuildInputs = [ gevent tornado twisted ];
  
  checkInputs = [ nose mock ];

  checkPhase = ''
    PIKA_TEST_TLS=true nosetests
  '';

  meta = with lib; {
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    homepage = "https://pika.readthedocs.org";
    license = licenses.bsd3;
  };

}
