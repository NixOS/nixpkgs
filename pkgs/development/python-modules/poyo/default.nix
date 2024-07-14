{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.5.0";
  format = "setuptools";
  pname = "poyo";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4mlWqngMRfARypiG8ERZDi2P2LYdt7HBz04IafSO1N0=";
  };

  meta = with lib; {
    homepage = "https://github.com/hackebrot/poyo";
    description = "Lightweight YAML Parser for Python";
    license = licenses.mit;
  };
}
