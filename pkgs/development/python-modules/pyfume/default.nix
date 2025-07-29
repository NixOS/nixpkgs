{
  lib,
  buildPythonPackage,
  fetchPypi,
  fst-pso,
  numpy,
  pandas,
  pythonOlder,
  scipy,
  setuptools,
  simpful,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyfume";
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UwW5OwFfu01lDKwz72iB2egbOoxb+t8UnEFIUjZmffU=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonRelaxDeps = [
    "fst-pso"
    "numpy"
    "pandas"
    "scipy"
  ];

  propagatedBuildInputs = [
    fst-pso
    numpy
    pandas
    scipy
    simpful
    typing-extensions
  ];

  # Module has not test
  doCheck = false;

  pythonImportsCheck = [ "pyfume" ];

  meta = with lib; {
    description = "Python package for fuzzy model estimation";
    homepage = "https://github.com/CaroFuchs/pyFUME";
    changelog = "https://github.com/CaroFuchs/pyFUME/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
