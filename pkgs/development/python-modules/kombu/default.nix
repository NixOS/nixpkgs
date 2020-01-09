{ lib
, buildPythonPackage
, fetchFromGitHub
, amqp
, case
, Pyro4
, pytz
, sqlalchemy
, pytest
, pytest-sugar
, fakeredis
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.6.7";

  src = fetchFromGitHub {
    owner = "celery";
    repo = "kombu";
    rev = version;
    sha256 = "1ra9dr590bpjjbj22rx4shwaclcyr261lzbw06axzdgnr1cqcbmx";
  };

  propagatedBuildInputs = [
    amqp
  ];

  checkInputs = [
    pytest
    case
    pytz
    Pyro4
    sqlalchemy
    fakeredis
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Messaging library for Python";
    homepage = https://github.com/celery/kombu;
    license = licenses.bsd3;
  };
}
