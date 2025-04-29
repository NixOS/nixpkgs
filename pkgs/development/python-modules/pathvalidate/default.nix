{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WbW5J44wOC1tITSXYjBD6+Y/EOKQVb5EGanATHIXOcs=";
  };

  build-system = [ setuptools-scm ];

  # Requires `pytest-md-report`, causing infinite recursion.
  doCheck = false;

  pythonImportsCheck = [ "pathvalidate" ];

  meta = with lib; {
    description = "Library to sanitize/validate a string such as filenames/file-paths/etc";
    homepage = "https://github.com/thombashi/pathvalidate";
    changelog = "https://github.com/thombashi/pathvalidate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ oxalica ];
  };
}
