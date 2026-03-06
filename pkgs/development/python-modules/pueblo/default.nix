{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  versioningit,
  attrs,
  platformdirs,
  tomli,
}:

buildPythonPackage rec {
  pname = "pueblo";
  version = "0.0.15";
  pyproject = true;

  # This tarball doesn't include tests unfortunately, and the GitHub tarball
  # could have been an alternative, but versioningit fails to detect the
  # version of it correctly, even with setuptools-scm and
  # SETUPTOOLS_SCM_PRETEND_VERSION = version added. Since this is a pure Python
  # package, we can rely on upstream to run the tests before releasing, and it
  # should work for us as well.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bz4ZxKp5oUfhLDMv0etJfDIPCoMcDtwCcA2hw+DAS8I=";
  };

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
    attrs
    platformdirs
    tomli
  ];

  doCheck = false; # no tests in sdist

  pythonImportsCheck = [ "pueblo" ];

  meta = {
    description = "Python toolbox library";
    homepage = "https://github.com/pyveci/pueblo";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
