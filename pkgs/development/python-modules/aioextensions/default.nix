{
  buildPythonPackage,
  fetchPypi,
  lib,

  # Python dependencies
  uvloop,
  pytest,
}:

buildPythonPackage rec {
  pname = "aioextensions";
  version = "21.7.2261349";
  format = "setuptools";

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

  meta = {
    description = "High performance functions to work with the async IO";
    homepage = "https://kamadorueda.github.io/aioextensions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
