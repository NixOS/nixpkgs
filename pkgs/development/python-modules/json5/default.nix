{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "json5";
  version = "0.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c3k5blbhq7g2lnbap26a846ag5x19ivisd3wfzz6bzdl46hyjqj";
  };

  # Necessary json5 test files aren't included in the download
  doCheck = false;
}

