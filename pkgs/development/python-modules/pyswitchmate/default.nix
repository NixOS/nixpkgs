{
  lib,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyswitchmate";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchmate";
    tag = version;
    hash = "sha256-14rjlIsSFNP2OzuRamAJw9BaA+Z5EuQBEsrD02uQdFk=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "switchmate" ];

  meta = {
    description = "A library to communicate with Switchmate";
    homepage = "https://github.com/Danielhiversen/pySwitchmate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
