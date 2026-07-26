{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-json-logger,
  setuptools,
}:

buildPythonPackage rec {
  pname = "logmatic-python";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "logmatic";
    repo = "logmatic-python";
    tag = version;
    hash = "sha256-UYKm00KhXnPQDkKJVm7s0gOwZ3GNY07O0oKbzPhAdVE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ python-json-logger ];

  # Only functional tests, no unit tests
  doCheck = false;

  pythonImportsCheck = [ "logmatic" ];

  meta = {
    description = "Python helpers to send logs to Logmatic.io";
    homepage = "https://github.com/logmatic/logmatic-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
