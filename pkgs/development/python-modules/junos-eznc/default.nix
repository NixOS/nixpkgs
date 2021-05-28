{ stdenv
, buildPythonPackage
, fetchPypi
, six
, scp
, pyserial
, paramiko
, netaddr
, ncclient
, ntc-templates
, lxml
, jinja2
, pyyaml
, transitions
, yamlordereddictloader
, nose
}:

buildPythonPackage rec {
  pname = "junos-eznc";
  version = "2.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "521659fe94da796897abc16773c3d84fa44d3e1f5386c71fbaef44cb80159855";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [
    scp six pyserial paramiko netaddr ncclient ntc-templates lxml jinja2 pyyaml transitions yamlordereddictloader
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
