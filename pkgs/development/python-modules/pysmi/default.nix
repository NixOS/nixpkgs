{ lib
, buildPythonPackage
, fetchPypi
, ply
}:

buildPythonPackage rec {
  version = "0.3.4";
  format = "setuptools";
  pname = "pysmi";

 src = fetchPypi {
    inherit pname version;
    sha256 = "bd15a15020aee8376cab5be264c26330824a8b8164ed0195bd402dd59e4e8f7c";
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
