{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycrypto
, pysmi
}:

buildPythonPackage rec {
  version = "4.3.2";
  pname = "pysnmp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xw925f3p02vdpb3f0ls60qj59w44aiyfs3s0nhdr9vsy4fxhavw";
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
