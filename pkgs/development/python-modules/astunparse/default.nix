{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "astunparse";
  version =  "1.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1kc9lm2jvfcip3z8snj04dar5a9jh857a704m6lvcv4xclm3rpsm";
  };
  propagatedBuildInputs = [ six ];
  doCheck = false; # no tests
  meta = with stdenv.lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
