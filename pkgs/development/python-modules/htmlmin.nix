{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "htmlmin";
  version = "0.1.12";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "50c1ef4630374a5d723900096a961cff426dff46b48f34d194a81bbe14eca178";
  };

  # Tests run fine in a normal source checkout, but not when being built by nix.
  doCheck = false;

  meta = {
    description = "A configurable HTML Minifier with safety features";
    homepage = https://pypi.python.org/pypi/htmlmin;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.ahmedtd];
  };
}
