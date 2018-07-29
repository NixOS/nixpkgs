{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, lxml
, libxml2
, libxslt
, nose
, rednose
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da7f7dfb8a60711610139e894b41ebcab3cd7103b78439ad5e9e91c2d3cfa423";
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
