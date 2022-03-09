{ buildPythonPackage, fetchPypi, lib, pytest }:

buildPythonPackage rec {
  pname = "pytest-pythonpath";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZOGVsjqPjAxjH7Fogtmtb6QTftHylh3dFdUgZc1DXbY=";
  };

  buildInputs = [ pytest ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description =
      "Pytest plugin for adding to the PYTHONPATH from command line or configs";
    homepage = "https://github.com/bigsassy/pytest-pythonpath";
    maintainers = with maintainers; [ cript0nauta ];
    license = licenses.mit;
  };
}
