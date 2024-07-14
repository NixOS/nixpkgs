{
  lib,
  fetchPypi,
  buildPythonPackage,
  colorama,
}:

buildPythonPackage rec {
  pname = "crayons";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vTO3VHgA8s+9JrOEMfnmS0h6fedKlHsPr8ibRaYBgT8=";
  };

  propagatedBuildInputs = [ colorama ];

  meta = with lib; {
    description = "TextUI colors for Python";
    homepage = "https://github.com/kennethreitz/crayons";
    license = licenses.mit;
  };
}
