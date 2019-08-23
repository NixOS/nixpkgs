{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "percol";
  version = "0.2.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a649c6fae61635519d12a6bcacc742241aad1bff3230baef2cedd693ed9cfe8";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mooz/percol;
    description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
