{ stdenv
, buildPythonPackage
, fetchPypi
, kerberos
}:

buildPythonPackage rec {
  pname = "kerberos";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19663qxmma0i8bfbjc2iwy5hgq0g4pfb75r023v5dps68zfvffgh";
  };

  nativeBuildInputs = [ kerberos ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Kerberos high-level interface";
    homepage = https://pypi.python.org/pypi/kerberos;
    license = licenses.asl20;
  };

}
