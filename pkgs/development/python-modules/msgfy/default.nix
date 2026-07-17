{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msgfy";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "msgfy";
    tag = "v${version}";
    hash = "sha256-wTUq44gx4lMwL5txg6/bCWIULPEFm8B/oUxkZIFb8JE=";
  };

  build-system = [ setuptools ];

  # msgfy has no runtime dependencies

  pythonImportsCheck = [ "msgfy" ];

  meta = {
    description = "Python library to convert exception objects to messages";
    homepage = "https://github.com/thombashi/msgfy";
    changelog = "https://github.com/thombashi/msgfy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
