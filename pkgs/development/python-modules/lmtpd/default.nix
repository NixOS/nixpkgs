{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "lmtpd";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "192d1j9lj9i6f4llwg51817am4jj8pjvlqmkx03spmsay6f832bm";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/moggers87/lmtpd;
    description = "LMTP counterpart to smtpd in the Python standard library";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
