{ stdenv
, buildPythonPackage
, fetchPypi
, six
, scp
, pyserial
, paramiko
, netaddr
, ncclient
, lxml
, jinja2
, pyyaml
, nose
}:

buildPythonPackage rec {
  pname = "junos-eznc";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0133a10ba3d46ddf70f0ba6620aa3b92e5533f08c57edd000dbffd8fe60d586d";
  };


  checkInputs = [ nose ];

  propagatedBuildInputs = [
    scp six pyserial paramiko netaddr ncclient lxml jinja2 pyyaml
  ];

  checkPhase = ''
    nosetests -v --with-coverage --cover-package=jnpr.junos --cover-inclusive -a unit
  '';

  meta = with stdenv.lib; {
    homepage = http://www.github.com/Juniper/py-junos-eznc;
    description = "Junos 'EZ' automation for non-programmers";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
