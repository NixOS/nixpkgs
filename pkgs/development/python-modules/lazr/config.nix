{ buildPythonPackage, fetchPypi, lazr_delegates }:

buildPythonPackage rec {
  pname = "lazr.config";
  version = "2.2.1";

  propagatedBuildInputs = [ lazr_delegates ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s7pyvlq06qjrkaw9r6nc290lb095n25ybzgavvy51ygpxkgqxwn";
  };
}
