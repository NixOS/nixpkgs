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
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "2.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe044273539250a99a5b9915843902e40e4e9b32ac5698c1fae89e31200d649f";
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

  # test dependencies are complex
  # and would require about 20 packages
  # to be added
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = https://docs.openstack.org/cliff/latest/;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
