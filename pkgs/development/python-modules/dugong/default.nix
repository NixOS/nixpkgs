{ buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "dugong";
  version = "3.7.5";

  disabled = pythonOlder "3.3"; # Library does not support versions older than 3.3

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "10vjdp21m0gzm096lgl84z184s5l9iz69ppj6acgsc125037dl6h";
  };
}
