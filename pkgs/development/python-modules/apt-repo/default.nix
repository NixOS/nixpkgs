{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,

  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "apt-repo";
  version = "0.5-unstable-2023-09-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brennerm";
    repo = "python-apt-repo";
    rev = "0287c59317f9ec8e8edbf7c228665a7010f758e7";
    hash = "sha256-9PA6AIeMXpaDc9g+rYpzwhf4ts3Xb31rvAUgDebTG4A=";
  };
  passthru.updateScript = unstableGitUpdater { };

  build-system = [ setuptools ];

  doCheck = false; # All tests require a network connection

  pythonImportsCheck = [ "apt_repo" ];

  meta = with lib; {
    description = "Python library to query APT repositories";
    homepage = "https://github.com/brennerm/python-apt-repo";
    license = licenses.mit;
    maintainers = with maintainers; [ nicoo ];
  };
}
