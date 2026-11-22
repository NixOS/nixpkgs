{
  buildPythonPackage,
  colorama,
  fetchPypi,
  lib,
  log-symbols,
  six,
  spinners,
  termcolor,
}:

buildPythonPackage (finalAttrs: {
  pname = "halo";
  version = "0.0.31";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-e2ejUh7pHVO3FS1O40UoEeHSpjIZdRN3Yus9cAY8ydY=";
  };

  propagatedBuildInputs = [
    colorama
    log-symbols
    termcolor
    six
    spinners
  ];

  # Tests are not included in the PyPI distribution and the git repo does not have tagged releases
  doCheck = false;
  pythonImportsCheck = [ "halo" ];

  meta = {
    description = "Beautiful Spinners for Terminal, IPython and Jupyter";
    homepage = "https://github.com/manrajgrover/halo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
})
