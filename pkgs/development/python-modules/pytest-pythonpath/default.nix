{ buildPythonPackage, fetchPypi, lib, pytest }:

buildPythonPackage rec {
  pname = "pytest-pythonpath";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qhxh0z2b3p52v3i0za9mrmjnb1nlvvyi2g23rf88b3xrrm59z33";
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
