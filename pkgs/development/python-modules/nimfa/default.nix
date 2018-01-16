{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, matplotlib
, pytest
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "nimfa";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05d0m5n96bg6wj94r7m1har48f93797gk5v9s62zdv7x83a6n6j5";
  };

  propagatedBuildInputs = [ numpy scipy ];
  buildInputs = [ matplotlib pytest ];
  doCheck = false; # errors

  meta = with stdenv.lib; {
    description = "Nonnegative matrix factorization library";
    homepage = "http://nimfa.biolab.si";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
