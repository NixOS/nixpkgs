{ lib, fetchPypi, buildPythonPackage
, openstackdocstheme
, unicodecsv
, pyyaml
, stevedore
, six
, pyparsing
, prettytable
, cmd2
, pbr
, subunit
, testrepository
, testtools
, mock
, testscenarios
, coverage
, sphinx
, bandit
, which
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "2.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ixlqlk3p0gxjqwy8n0xvs0kwijvh1842gqj2lly6x3wf6sgnl5b";
  };

  propagatedBuildInputs = [
    openstackdocstheme
    unicodecsv
    pyyaml
    stevedore
    six
    pyparsing
    prettytable
    cmd2
    pbr
  ];

  checkInputs = [
    subunit
    testrepository
    testtools
    mock
    testscenarios
    coverage
    sphinx
    bandit
    which
  ];

  # formatting test fails with current version
  preCheck = ''
    rm cliff/tests/test_formatters_table.py
  '';

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://docs.openstack.org/cliff/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
