{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstring";
  version = "3.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1algq30j6rz12b1902bpw7iijx5lhrfqhl80d4ac6xzkrrpshqy1";
    extension = "zip";
  };

  meta = with stdenv.lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
