{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycryptodomex
, pysmi
}:

buildPythonPackage rec {
  version = "4.4.8";
  pname = "pysnmp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c42qicrh56m49374kxna2s2nmdwna3yqgnz16frzj0dw7vxrrhk";
  };

  # NameError: name 'mibBuilder' is not defined
  doCheck = false;

  propagatedBuildInputs = [ pyasn1 pycryptodomex pysmi ];

  meta = with stdenv.lib; {
    homepage = http://pysnmp.sf.net;
    description = "A pure-Python SNMPv1/v2c/v3 library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ koral ];
  };
}
