{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  versioningit,
  attrs,
  platformdirs,
  tomli,
}:

buildPythonPackage rec {
  pname = "pueblo";
  version = "0.0.11";
  pyproject = true;

  disabled = pythonOlder "3.11";

  # This tarball doesn't include tests unfortunately, and the GitHub tarball
  # could have been an alternative, but versioningit fails to detect the
  # version of it correctly, even with setuptools-scm and
  # SETUPTOOLS_SCM_PRETEND_VERSION = version added. Since this is a pure Python
  # package, we can rely on upstream to run the tests before releasing, and it
  # should work for us as well.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IQ5NFn1EMh5oLgRlth7VWQmSyMx2/7cmC/U1VW1B4OE=";
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

  meta = with lib; {
    description = "Python toolbox library";
    homepage = "https://github.com/pyveci/pueblo";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ doronbehar ];
  };
}
