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
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iqcrr48jwy7nh8g13xf4rvpw9wq5qs3hyd6gqlh30mgyn9i85w7";
  };

  propagatedBuildInputs = [ numpy scipy ];
  checkInputs = [ matplotlib pytest ];
  doCheck = !isPy3k;  # https://github.com/marinkaz/nimfa/issues/42

  meta = with stdenv.lib; {
    description = "Nonnegative matrix factorization library";
    homepage = "http://nimfa.biolab.si";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
