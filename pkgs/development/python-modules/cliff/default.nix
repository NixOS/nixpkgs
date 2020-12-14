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
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bfb684b5fcdff0afaaccd1298a376c0e62e644c46b7e9abc034595b41fe1759";
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
    sed -i '/PrettyTable/c\PrettyTable' requirements.txt
  '';

  # Tests do not seem to work
  doCheck = false;
  pythonImportsCheck = [ "cliff" ];

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://docs.openstack.org/cliff/latest/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
