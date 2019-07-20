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
  version = "0.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b367354d1cd25b79b8798a0b4c1949590d890057f2a252e6e970a9ab744e009";
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
