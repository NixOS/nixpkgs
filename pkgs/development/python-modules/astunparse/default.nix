{ lib
, fetchPypi
, buildPythonPackage
, six
, wheel
 }:

buildPythonPackage rec {
  pname = "astunparse";
  version =  "1.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872";
  };

  propagatedBuildInputs = [ six wheel ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    homepage = "https://github.com/simonpercivall/astunparse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
