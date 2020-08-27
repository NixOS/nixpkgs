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
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e3a1e74b9254b4832a6cdbf8e6f26f9a269f574cb8cf2dd292dc131e0f4b245";
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
