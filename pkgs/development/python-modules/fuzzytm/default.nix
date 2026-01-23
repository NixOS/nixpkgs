{
  lib,
  buildPythonPackage,
  fetchPypi,
  gensim,
  numpy,
  pandas,
  pyfume,
  setuptools,
  scipy,
}:

buildPythonPackage rec {
  pname = "fuzzytm";
  version = "2.0.9";
  pyproject = true;

  src = fetchPypi {
    pname = "FuzzyTM";
    inherit version;
    hash = "sha256-z0ESYtB7BqssxIHlrd0F+/qapOM1nrDi3Zih5SvgDGY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gensim
    numpy
    pandas
    pyfume
    scipy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "FuzzyTM" ];

  meta = {
    description = "Library for Fuzzy Topic Models";
    homepage = "https://github.com/ERijck/FuzzyTM";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
