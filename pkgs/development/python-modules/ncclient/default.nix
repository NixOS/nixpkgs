{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, lxml
, libxml2
, libxslt
, pytest
, nose
, rednose
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe6b9c16ed5f1b21f5591da74bfdd91a9bdf69eb4e918f1c06b3c8db307bd32b";
  };

  checkInputs = [ nose rednose ];

  propagatedBuildInputs = [
    paramiko lxml libxml2 libxslt
  ];

  checkPhase = ''
    nosetests test --rednose --verbosity=3 --with-coverage --cover-package ncclient
  '';

  #Unfortunately the test hangs at te end
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://ncclient.org/;
    description = "Python library for NETCONF clients";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
