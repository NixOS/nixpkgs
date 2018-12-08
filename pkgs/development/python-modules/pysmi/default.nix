{ stdenv
, buildPythonPackage
, fetchPypi
, ply
}:

buildPythonPackage rec {
  version = "0.3.2";
  pname = "pysmi";

 src = fetchPypi {
    inherit pname version;
    sha256 = "309039ab9bd458cc721692ffff10b4ad2c4a8e731e6507c34866ca2727323353";
  };

  propagatedBuildInputs = [ ply ];

  # Tests require pysnmp, which in turn requires pysmi => infinite recursion
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pysmi.sf.net;
    description = "SNMP SMI/MIB Parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ koral ];
  };

}
