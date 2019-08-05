{ stdenv, buildPythonPackage, fetchPypi,
  requests, mt-940, sepaxml, bleach, isPy3k }:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "fints";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1apsxin6a7535vwc0kp82i1wzsg94imb4h18r8cdwjslb6wy4gwz";
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
