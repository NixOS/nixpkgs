{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "3.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sYwHISv+rWJDRbuOHWFBzc8Vo5c2mU6guUA1rSsboXc=";
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
