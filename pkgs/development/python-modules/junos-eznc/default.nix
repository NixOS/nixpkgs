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
  version = "2.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eee93d0af203af7cee54a8f0c7bd28af683e829edf1fd68feba85d0ad737395";
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

  pythonImportsCheck = [ "jnpr.junos" ];

  meta = with lib; {
    homepage = "http://www.github.com/Juniper/py-junos-eznc";
    description = "Junos 'EZ' automation for non-programmers";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
