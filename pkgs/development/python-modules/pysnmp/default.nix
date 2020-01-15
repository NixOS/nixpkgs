{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycryptodomex
, pysmi
}:

buildPythonPackage rec {
  pname = "pysnmp";
  version = "4.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v7vz045pami4nx5hfvk8drarcswjclb0pfmg932x95fddbdx2zy";
  };

  # NameError: name 'mibBuilder' is not defined
  doCheck = false;

  propagatedBuildInputs = [ pyasn1 pycryptodomex pysmi ];

  meta = with stdenv.lib; {
    homepage = http://snmplabs.com/pysnmp/index.html;
    description = "A pure-Python SNMPv1/v2c/v3 library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ primeos koral ];
  };
}
