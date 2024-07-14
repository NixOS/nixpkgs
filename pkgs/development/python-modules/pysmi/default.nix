{
  lib,
  buildPythonPackage,
  fetchPypi,
  ply,
}:

buildPythonPackage rec {
  version = "0.3.4";
  format = "setuptools";
  pname = "pysmi";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vRWhUCCu6Ddsq1viZMJjMIJKi4Fk7QGVvUAt1Z5Oj3w=";
  };

  propagatedBuildInputs = [ ply ];

  # Tests require pysnmp, which in turn requires pysmi => infinite recursion
  doCheck = false;

  meta = with lib; {
    homepage = "http://pysmi.sf.net";
    description = "SNMP SMI/MIB Parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ koral ];
  };
}
