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
    hash = "sha256-UMHvRjA3Sl1yOQAJapYc/0Jt/0a0jzTRlKgbvhTsoXg=";
  };

  # Tests run fine in a normal source checkout, but not when being built by nix.
  doCheck = false;

  meta = with lib; {
    description = "Configurable HTML Minifier with safety features";
    mainProgram = "htmlmin";
    homepage = "https://pypi.python.org/pypi/htmlmin";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
