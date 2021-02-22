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
  version = "0.6.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0112f2ad41fb658f52446d870853a63691d69299c73c7351c520d38dbd8dc0c4";
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
