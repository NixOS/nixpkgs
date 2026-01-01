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
<<<<<<< HEAD
  version = "0.0.13";
=======
  version = "0.0.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    hash = "sha256-EewRittG90ZHRklGtXHtEJ83DWzA6f0iKfX87YlmVgY=";
=======
    hash = "sha256-oo2RNJQUVDqxhfBI6h1KCAgsMjDe7ns3F9qD4eKLVic=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python toolbox library";
    homepage = "https://github.com/pyveci/pueblo";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
=======
  meta = with lib; {
    description = "Python toolbox library";
    homepage = "https://github.com/pyveci/pueblo";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ doronbehar ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
