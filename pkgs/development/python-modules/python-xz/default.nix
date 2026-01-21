{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-xz";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yNxRBweZ7p533dndIHoRzJFw6SmFQvgecYcHLg1UNHg=";
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
