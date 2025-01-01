{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  versioningit,
  platformdirs,
}:

buildPythonPackage rec {
  pname = "pueblo";
  version = "0.0.10";
  pyproject = true;

  # This tarball doesn't include tests unfortuneatly, and the GitHub tarball
  # could have been an alternative, but versioningit fails to detect the
  # version of it correctly, even with setuptools-scm and
  # SETUPTOOLS_SCM_PRETEND_VERSION = version added. Since this is a pure Python
  # package, we can rely on upstream to run the tests before releasing, and it
  # should work for us as well.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7uFLlApTR58KiV7yRydo37RsVE4QPvTbjgYNEG64mUo=";
  };

  nativeBuildInputs = [
    setuptools
    versioningit
  ];

  propagatedBuildInputs = [
    #  contextlib-chdir
    #  importlib-metadata
    platformdirs
  ];

  pythonImportsCheck = [ "pueblo" ];

  meta = with lib; {
    description = "Pueblo - a Python toolbox library";
    homepage = "https://pypi.org/project/pueblo/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ doronbehar ];
  };
}
