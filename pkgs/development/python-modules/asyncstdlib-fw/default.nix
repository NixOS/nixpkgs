{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "asyncstdlib-fw";
  version = "3.13.2";
  pyproject = true;

  # Not available from any repo
  src = fetchPypi {
    pname = "asyncstdlib_fw";
    inherit version;
    hash = "sha256-Ua0JTCBMWTbDBA84wy/W1UmzkcmA8h8foJW2X7aAah8=";
  };

  build-system = [
    pdm-backend
  ];

  doCheck = false; # no tests supplied

  pythonImportsCheck = [
    "asyncstdlib"
  ];

  meta = {
    description = "Fork of asyncstdlib that work with fireworks-ai";
    homepage = "https://pypi.org/project/asyncstdlib-fw/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
