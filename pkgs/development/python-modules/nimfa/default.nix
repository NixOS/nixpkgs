{ lib
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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39cff2b86856d03ca8a3d9c38598034ecf1a768c325fd3a728bb9eadb8c6b919";
  };

  propagatedBuildInputs = [ numpy scipy ];
  nativeCheckInputs = [ matplotlib pytest ];
  doCheck = !isPy3k;  # https://github.com/marinkaz/nimfa/issues/42

  meta = with lib; {
    description = "Nonnegative matrix factorization library";
    homepage = "http://nimfa.biolab.si";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
