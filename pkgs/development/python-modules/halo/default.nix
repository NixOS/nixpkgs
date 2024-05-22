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
    sha256 = "1mn97h370ggbc9vi6x8r6akd5q8i512y6kid2nvm67g93r9a6rvv";
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
    description = "Beautiful Spinners for Terminal, IPython and Jupyter.";
    homepage = "https://github.com/manrajgrover/halo";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
