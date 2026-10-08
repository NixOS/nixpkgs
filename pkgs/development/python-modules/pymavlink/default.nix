{
  lib,
  buildPythonPackage,
  cython,
  fastcrc,
  fetchPypi,
  lxml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.49";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-188Q1VktA4oYqpcnERd+u4i+IUPvzCWN9jCwUT6dosI=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    fastcrc
    lxml
  ];

  # No tests included in PyPI tarball. We cannot use the GitHub tarball because
  # we would like to use the same commit of the mavlink messages repo as
  # included in the PyPI tarball, and there is no easy way to determine what
  # commit is included.
  doCheck = false;

  pythonImportsCheck = [ "pymavlink" ];

  meta = {
    description = "Python MAVLink interface and utilities";
    homepage = "https://github.com/ArduPilot/pymavlink";
    changelog = "https://github.com/ArduPilot/pymavlink/releases/tag/${version}";
    license = with lib.licenses; [
      lgpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [ lopsided98 ];
  };
}
