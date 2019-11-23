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
  version = "2.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "622e777b8ac2eb479708fe53893c37b2fd5469ce2c6c5b794a658246f05c6b81";
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
