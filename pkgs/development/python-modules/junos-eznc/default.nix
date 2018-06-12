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
  version = "2.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "daa62e5abfc66ef12e4fb43a1c264673e662e6f2d937cd10666c1c6dcf2ac6ac";
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
