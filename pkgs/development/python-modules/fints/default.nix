{ stdenv, buildPythonPackage, fetchPypi,
  requests, mt-940, sepaxml, bleach, isPy3k }:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "fints";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "27427b5e6536b592f964c464a8f0c75c5725176604e9d0f208772a45918d9b78";
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
