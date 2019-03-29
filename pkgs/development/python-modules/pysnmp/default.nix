{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycryptodomex
, pysmi
}:

buildPythonPackage rec {
  version = "4.4.9";
  pname = "pysnmp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h844s9p67z50bv83wdyf577759jg0xrj99fv4yrcvhjh2byblfm";
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
