{
  lib,
  buildPythonPackage,
  fetchPypi,
  docutils,
  six,
}:

buildPythonPackage rec {
  pname = "bcdoc";
  version = "0.16.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f568c182e06883becf7196f227052435cffd45604700c82362ca77d3427b6202";
  };

  buildInputs = [
    docutils
    six
  ];

  # Tests fail due to nix file timestamp normalization.
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/boto/bcdoc";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://github.com/boto/bcdoc";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "ReST document generation tools for botocore";
  };
}
