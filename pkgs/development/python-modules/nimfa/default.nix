{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, numpy
, scipy
, matplotlib
, pytest
}:

buildPythonPackage rec {
  pname = "nimfa";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "651376eba6b049fe270dc0d29d4b2abecb5e998c2013df6735a97875503e2ffe";
  };

  propagatedBuildInputs = [ numpy scipy ];
  checkInputs = [ matplotlib pytest ];
  doCheck = !isPy3k;  # https://github.com/marinkaz/nimfa/issues/42

  meta = with stdenv.lib; {
    description = "Nonnegative matrix factorization library";
    homepage = http://nimfa.biolab.si;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
