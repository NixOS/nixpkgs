{
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonOlder,

  # Python dependencies
  uvloop,
  pytest,
}:

buildPythonPackage rec {
  pname = "aioextensions";
  version = "21.7.2261349";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LqzFJpJJXzMUN+jI6Xgspx9GF+yE8XTKF6zdd2Me/Ec=";
  };

  propagatedBuildInputs = [ uvloop ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    cd test/
    pytest
  '';

  meta = with lib; {
    description = "High performance functions to work with the async IO";
    homepage = "https://kamadorueda.github.io/aioextensions";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
