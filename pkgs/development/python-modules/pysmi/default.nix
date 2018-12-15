{ stdenv
, buildPythonPackage
, fetchPypi
, ply
}:

buildPythonPackage rec {
  version = "0.0.7";
  pname = "pysmi";

 src = fetchPypi {
    inherit pname version;
    sha256 = "05h1lv2a687b9qjc399w6728ildx7majbn338a0c4k3gw6wnv7wr";
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
