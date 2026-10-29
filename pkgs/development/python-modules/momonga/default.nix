{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyserial,
  setuptools,
}:

buildPythonPackage rec {
  pname = "momonga";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbtk";
    repo = "momonga";
    tag = "v${version}";
    hash = "sha256-ZzQPJcvjRuRjU/u8KjxZ0C4XUb4fbVkLIcsf2JmzDRA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
  ];

  pythonImportsCheck = [ "momonga" ];

  # tests require access to the API
  doCheck = false;

  meta = {
    changelog = "https://github.com/nbtk/momonga/releases/tag/${src.tag}";
    description = "Python Route B Library: A Communicator for Low-voltage Smart Electric Energy Meters";
    homepage = "https://github.com/nbtk/momonga";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
