{ buildPythonPackage, fetchPypi, isPy3k, lib }:

buildPythonPackage rec {
  pname = "lmtpd";
  version = "6.2.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c6825d2ffa1de099440411a742f58e1b3e8deeb3345adcfd4c2c38d4baf62b3";
  };

  meta = with lib; {
    homepage = "https://github.com/moggers87/lmtpd";
    description = "LMTP counterpart to smtpd in the Python standard library";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
