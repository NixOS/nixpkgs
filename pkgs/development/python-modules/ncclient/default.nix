{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, selectors2
, lxml
, libxml2
, libxslt
, nose
, rednose
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ab58ee0d71069cb5b0e2f29a4e605d1d8417bd10af45b73ee3e817fe389fadc";
  };

  checkInputs = [ nose rednose ];

  propagatedBuildInputs = [
    paramiko lxml libxml2 libxslt selectors2
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
