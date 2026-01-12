{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-xz";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oYjwQ26BFFXxvaYdzp2+bw/BQwM0v/n1r9DmaLs1R3Q=";
  };

  build-system = [ setuptools-scm ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "xz" ];

  meta = {
    description = "Pure Python library for seeking within compressed xz files";
    homepage = "https://github.com/Rogdham/python-xz";
    changelog = "https://github.com/Rogdham/python-xz/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = lib.platforms.all;
  };
}
