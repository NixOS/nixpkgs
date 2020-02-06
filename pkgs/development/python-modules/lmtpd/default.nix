{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "lmtpd";
  version = "6.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "256e23a3292818ecccf9a76ef52e0064c6f7e1f8602904e15337c8917ed0fafe";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/moggers87/lmtpd;
    description = "LMTP counterpart to smtpd in the Python standard library";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
