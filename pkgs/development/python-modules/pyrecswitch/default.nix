{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrecswitch";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcolertora";
    repo = "pyrecswitch";
    tag = version;
    hash = "sha256-z9dOJ7WgUR2ntU6boUInRyKxSPBSoNWGtE3pOZcFYA0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodome ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrecswitch" ];

  meta = {
    description = "Pure-python interface for controlling Ankuoo RecSwitch MS6126";
    homepage = "https://github.com/marcolertora/pyrecswitch";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
