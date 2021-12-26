{ buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.7.1";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c0ac8c4ee57b2adddc82909d3c738a62ef5f77faf24ec7cb6f0a117e1679740";
  };
}
