{
  buildPythonPackage,
  colorama,
  fetchPypi,
  isPy27,
  lib,
  log-symbols,
  six,
  spinners,
  termcolor,
}:

buildPythonPackage rec {
  pname = "halo";
  version = "0.0.31";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "Beautiful Spinners for Terminal, IPython and Jupyter";
    homepage = "https://github.com/manrajgrover/halo";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
