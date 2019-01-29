{ stdenv, buildPythonPackage, fetchPypi,
  requests, mt-940, sepaxml, bleach, isPy3k }:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "fints";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jja83h0ld55djiphcxdz64z5qp3w94204bfbgg65v5ybw0vpqq1";
  };

  propagatedBuildInputs = [ requests mt-940 sepaxml bleach ];

  # no tests included in PyPI package
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/raphaelm/python-fints/;
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
