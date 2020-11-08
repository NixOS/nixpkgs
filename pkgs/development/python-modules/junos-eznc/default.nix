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
  version = "2.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf036d0af9ee5c5e4f517cb5fc902fe891fa120e18f459805862c53d4a97193a";
  };

  checkInputs = [ nose ];

  requiredPythonModules = [
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
