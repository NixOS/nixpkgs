{ lib
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
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f5de7dedaac8dd71bfea23c6a7d883e29947c91de1ba299a9242e0a4406ee46";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "ncclient==0.6.9" "ncclient"
  '';

  checkInputs = [ nose ];

  propagatedBuildInputs = [
    scp six pyserial paramiko netaddr ncclient ntc-templates lxml jinja2 pyyaml transitions yamlordereddictloader
  ];

  checkPhase = ''
    nosetests -v --with-coverage --cover-package=jnpr.junos --cover-inclusive -a unit
  '';

  meta = with lib; {
    homepage = "http://www.github.com/Juniper/py-junos-eznc";
    description = "Junos 'EZ' automation for non-programmers";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
