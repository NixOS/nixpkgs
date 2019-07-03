{ stdenv, buildPythonPackage, fetchPypi,
  requests, mt-940, sepaxml, bleach, isPy3k }:

buildPythonPackage rec {
  version = "2.1.1";
  pname = "fints";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06p6p0xxw0n10hmf7z4k1l29fya0sja433s6lasjr1bal5asdhaq";
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
