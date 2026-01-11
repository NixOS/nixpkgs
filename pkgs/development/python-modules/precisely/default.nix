{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "precisely";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-precisely";
    tag = version;
    hash = "sha256-jvvRreSGpRgDk1bbqC8Z/UEfvxwKilfc/sm7nxdJU6k=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "precisely" ];

  # Tests are outdated and based on Nose, which is not supported anymore.
  doCheck = false;

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Matcher library for Python";
    homepage = "https://github.com/mwilliamson/python-precisely";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
