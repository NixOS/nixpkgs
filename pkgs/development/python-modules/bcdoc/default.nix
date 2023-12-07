{ lib, buildPythonPackage, fetchPypi, docutils, six }:

buildPythonPackage rec {
  pname = "bcdoc";
  version = "0.16.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f568c182e06883becf7196f227052435cffd45604700c82362ca77d3427b6202";
  };

  buildInputs = [ docutils six ];

  # Tests fail due to nix file timestamp normalization.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/boto/bcdoc";
    license = licenses.asl20;
    description = "ReST document generation tools for botocore";
  };
}
