{ stdenv
, buildPythonPackage
, fetchPypi
, ply
}:

buildPythonPackage rec {
  version = "0.3.3";
  pname = "pysmi";

 src = fetchPypi {
    inherit pname version;
    sha256 = "0bzhmi4691rf306n4y82js52532h3fp1sy6phvh6hnms6nww4daf";
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
