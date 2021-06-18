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
  version = "0.6.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37c8a9f9a44f0346144119ab17ae6559e44b5a991f4c34ea3765c678079e4beb";
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
