{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "astunparse";
  version =  "1.6.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "d27b16fb33dea0778c5a2c01801554eae0d3f8a8d6f604f15627589c3d6f11ca";
  };
  propagatedBuildInputs = [ six ];
  doCheck = false; # no tests
  meta = with stdenv.lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
