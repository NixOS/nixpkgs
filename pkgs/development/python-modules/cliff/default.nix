{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, cmd2
, attrs
, prettytable
, pyparsing
, six
, stevedore
, unicodecsv
, pyyaml
, subunit
, testrepository
, testtools
, mock
, testscenarios
, coverage
, sphinx
, pkgs
}:

buildPythonPackage rec {
  version = "2.13.0";
  pname = "cliff";

  src = fetchPypi {
    inherit pname version;
    sha256 = "447f0afe5fab907c51e3e451e6915cba424fe4a98962a5bdd7d4420b9d6aed35";
  };

  checkInputs = [ subunit testrepository testtools mock testscenarios coverage sphinx pkgs.which ];
  propagatedBuildInputs = [ pbr cmd2 attrs prettytable pyparsing six stevedore unicodecsv pyyaml ];

  meta = with stdenv.lib; {
    homepage = https://docs.openstack.org/cliff/latest/;
    description = "Command Line Interface Formulation Framework";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
