{ lib, buildPythonPackage, fetchPypi, isPy3k, krb5Full, nose, GitPython, mock, git }:

buildPythonPackage rec {
  pname = "CCColUtils";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gwcq4xan9as1j3q9k2zqrywxp46qx0ljwxbck9id2fvilds6ck3";
  };

  buildInputs = [ krb5Full ];
  propagatedBuildInputs = [ nose GitPython mock git ];

  doCheck = isPy3k; # needs unpackaged module to run tests on python2

  meta = with lib; {
    description = "Python Kerberos 5 Credential Cache Collection Utilities";
    homepage = "https://pagure.io/cccolutils";
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
  };
}
