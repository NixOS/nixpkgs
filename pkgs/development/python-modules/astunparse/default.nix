{ stdenv
, fetchPypi
, buildPythonPackage
, six
, wheel
 }:

buildPythonPackage rec {
  pname = "astunparse";
  version =  "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d27b16fb33dea0778c5a2c01801554eae0d3f8a8d6f604f15627589c3d6f11ca";
  };

  propagatedBuildInputs = [ six wheel ];

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    homepage = https://github.com/simonpercivall/astunparse;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
