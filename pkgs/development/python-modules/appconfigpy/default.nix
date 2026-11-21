{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  loguru,
}:

buildPythonPackage rec {
  pname = "appconfigpy";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "appconfigpy";
    tag = "v${version}";
    hash = "sha256-qXnS5NOILWvmGhTzOOBcLivhs7Y9vY72xinr3l7MZHA=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    logging = [ loguru ];
  };

  pythonImportsCheck = [ "appconfigpy" ];

  meta = {
    description = "Python library to manage configuration files";
    homepage = "https://github.com/thombashi/appconfigpy";
    changelog = "https://github.com/thombashi/appconfigpy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
