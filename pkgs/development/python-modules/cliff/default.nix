{ lib
, buildPythonPackage
, fetchPypi
, pbr
, prettytable
, pyparsing
, six
, stevedore
, pyyaml
, unicodecsv
, cmd2
, pytest
, mock
, testtools
, fixtures
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49be854582ec4a74240cb72f287846f823cd8cbd2e25f924541d12f27104bda3";
  };

  propagatedBuildInputs = [
    pbr
    prettytable
    pyparsing
    six
    stevedore
    pyyaml
    cmd2
    unicodecsv
  ];

  # remove version constraints
  postPatch = ''
    sed -i '/cmd2/c\cmd2' requirements.txt
  '';

  checkInputs = [ fixtures mock pytest testtools ];
  # add some tests
  checkPhase = ''
    pytest cliff/tests/test_{utils,app,command,help,lister}.py \
      -k 'not interactive_mode'
  '';

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://docs.openstack.org/cliff/latest/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
