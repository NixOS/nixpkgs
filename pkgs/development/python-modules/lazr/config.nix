{ buildPythonPackage, fetchPypi, lazr_delegates }:

buildPythonPackage rec {
  pname = "lazr.config";
  version = "2.2.2";

  propagatedBuildInputs = [ lazr_delegates ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdb9a70dac4a76ca1ff3528d9eafe5414c6c69c1b92e7e84d3477ae85f6bb787";
  };
}
