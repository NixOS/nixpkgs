{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vs9nyf9w3655j1vv3abxj4vbig61c0hjmhpfb91gblv32shl15a";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Node.js virtual environment builder";
    homepage = https://github.com/ekalinin/nodeenv;
    license = licenses.bsd3;
  };
}
