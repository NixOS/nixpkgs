{ lib
, buildPythonPackage
, fetchPypi
, paramiko
, selectors2
, lxml
, nose
, rednose
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67b1eba5a6c7c6075746d8c33d4e8f4ded17604034c1fcd1c78996ef52bf66ff";
  };

  checkInputs = [ nose rednose ];

  propagatedBuildInputs = [
    paramiko lxml selectors2
  ];

  checkPhase = ''
    nosetests test --rednose --verbosity=3 --with-coverage --cover-package ncclient
  '';

  #Unfortunately the test hangs at te end
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ncclient/ncclient";
    description = "Python library for NETCONF clients";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
