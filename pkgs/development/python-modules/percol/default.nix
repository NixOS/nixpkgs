{ lib, buildPythonPackage, fetchPypi, isPy3k
, six
}:

buildPythonPackage rec {
  pname = "percol";
  version = "0.2.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a649c6fae61635519d12a6bcacc742241aad1bff3230baef2cedd693ed9cfe8";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/mooz/percol";
    description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
    broken = true; # missing cmigemo package which is missing libmigemo.so
    # also doesn't support python3
  };
}
