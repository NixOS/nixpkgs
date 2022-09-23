{ buildPythonPackage, fetchPypi, lazr_delegates }:

buildPythonPackage rec {
  pname = "lazr.config";
  version = "2.2.3";

  propagatedBuildInputs = [ lazr_delegates ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b74a73f8b63e6dc6732fc1f3d88e2f236596ddf089ef6e1794ece060e8cfabe1";
  };
}
