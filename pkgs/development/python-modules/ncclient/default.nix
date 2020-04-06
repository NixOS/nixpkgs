{ stdenv
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
  version = "0.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efdf3c868cd9f104d4e9fe4c233df78bfbbed4b3d78ba19dc27cec3cf6a63680";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/ncclient/ncclient";
    description = "Python library for NETCONF clients";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
