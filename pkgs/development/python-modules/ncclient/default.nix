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
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47d5af7398f16d609eebd02be2ecbd997b364032b5dc6d4927c810ea24f39080";
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
