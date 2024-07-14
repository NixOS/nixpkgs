{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pythonAtLeast,
  cython,
  numpy,
}:

buildPythonPackage rec {
  pname = "pkuseg";
  version = "0.0.25";
  format = "setuptools";

  disabled = !isPy3k || pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3QEr+TaJchyVdLwrK6mPtKwieQzsCvNUp44heCi4HpE=";
  };

  # Does not seem to have actual tests, but unittest discover
  # recognizes some non-tests as tests and fails.
  doCheck = false;

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "pkuseg" ];

  meta = with lib; {
    description = "Toolkit for multi-domain Chinese word segmentation";
    homepage = "https://github.com/lancopku/pkuseg-python";
    license = licenses.unfree;
  };
}
