{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "htmlmin";
  version = "0.1.12";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "50c1ef4630374a5d723900096a961cff426dff46b48f34d194a81bbe14eca178";
  };

  # Tests run fine in a normal source checkout, but not when being built by nix.
  doCheck = false;

  meta = with lib; {
    description = "A configurable HTML Minifier with safety features";
    mainProgram = "htmlmin";
    homepage = "https://pypi.python.org/pypi/htmlmin";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
