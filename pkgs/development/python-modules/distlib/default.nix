{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8VIJciSgriS+Wg9rrhuTWa+CEzvOY/mKlfhsrhrt6e0=";
  };

  nativeBuildInputs = [ setuptools ];

  postFixup = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    find $out -name '*.exe' -delete
  '';

  pythonImportsCheck = [
    "distlib"
    "distlib.database"
    "distlib.locators"
    "distlib.index"
    "distlib.markers"
    "distlib.metadata"
    "distlib.util"
    "distlib.resources"
  ];

  # Tests use pypi.org.
  doCheck = false;

  meta = {
    description = "Low-level components of distutils2/packaging";
    homepage = "https://distlib.readthedocs.io";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
