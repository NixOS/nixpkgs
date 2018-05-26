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
  version = "2.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95a037cdd05618a189517357e46a06886909a18c7923b628c6ac43d5f54b2912";
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
