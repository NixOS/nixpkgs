{
  lib,
  buildPythonPackage,
  colorlog,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pypca";
  version = "0.0.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y0p2rm22x21mykipiv42fjc79b0969qsbhk3cqkrdnqwh5psbdl";
  };

  propagatedBuildInputs = [
    colorlog
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypca" ];

  meta = {
    description = "Python library for interacting with the PCA 301 smart plugs";
    mainProgram = "pypca";
    homepage = "https://github.com/majuss/pypca";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
