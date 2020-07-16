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
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f3ecf06ab4d630f27e7ed7a7b605122ee5c5e5386b1f5186f6cb52810750b18";
  };


  checkInputs = [ nose ];

  propagatedBuildInputs = [
    scp six pyserial paramiko netaddr ncclient lxml jinja2 pyyaml
  ];

  checkPhase = ''
    nosetests -v --with-coverage --cover-package=jnpr.junos --cover-inclusive -a unit
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.github.com/Juniper/py-junos-eznc";
    description = "Junos 'EZ' automation for non-programmers";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
