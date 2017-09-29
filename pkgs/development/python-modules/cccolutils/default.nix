{ stdenv, buildPythonPackage, fetchPypi, krb5Full, nose, GitPython, mock, git }:

buildPythonPackage rec {
  pname = "CCColUtils";
  version = "1.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gwcq4xan9as1j3q9k2zqrywxp46qx0ljwxbck9id2fvilds6ck3";
  };
  buildInputs = [ krb5Full ];
  propagatedBuildInputs = [ nose GitPython mock git ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Kerberos 5 Credential Cache Collection Utilities";
    homepage = https://pagure.io/cccolutils;
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
  };
}
