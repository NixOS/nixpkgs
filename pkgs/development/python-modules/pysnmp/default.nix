{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycrypto
, pysmi
}:

buildPythonPackage rec {
  version = "4.4.6";
  pname = "pysnmp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e34ffa0dce5f69adabd478ff76c3e1b08e32ebb0767df8b178d0704f4a1ac406";
  };

  # NameError: name 'mibBuilder' is not defined
  doCheck = false;

  propagatedBuildInputs = [ pyasn1 pycrypto pysmi ];

  meta = with stdenv.lib; {
    homepage = http://pysnmp.sf.net;
    description = "A pure-Python SNMPv1/v2c/v3 library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ koral ];
  };

}
