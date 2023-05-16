{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "python-vagrant";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "python-vagrant";
    rev = "refs/tags/v${version}";
    hash = "sha256-apvYzH0IY6ZyUP/FiOVbGN3dXejgN7gn7Mq2tlEaTww=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
=======
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "python-vagrant";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qP6TzPL/N+zJXsL0nqdKkabOc6TbShapjdJtOXz9CeU=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # The tests try to connect to qemu
  doCheck = false;

  pythonImportsCheck = [
    "vagrant"
  ];

  meta = {
    description = "Python module that provides a thin wrapper around the vagrant command line executable";
    homepage = "https://github.com/todddeluca/python-vagrant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
