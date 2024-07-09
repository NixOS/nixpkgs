{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blessings";
  version = "1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mOWFTYBfUKW1isIzNBGwSCUWqCEPI/QzCLrrWNd8FX0=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # Running tests produces a failure that's not able to be patched easily.
  # See PR #165 in the repo for the package for more information.
  doCheck = false;

  pythonImportsCheck = [ "blessings" ];

  meta = {
    homepage = "https://github.com/erikrose/blessings";
    description = "Thin, practical wrapper around terminal coloring, styling, and positioning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
