{
  lib,
  buildPythonPackage,
  crc16,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "pyoppleio-legacy";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinysnake";
    repo = "python-oppleio-legacy";
    rev = "90c57f778554fcf3a00e42757d0e92caebcfd149";
    hash = "sha256-ccvMn/jQSkW11uMwG3P+i53NiDj+MNZgJYEkouQ1tvU=";
  };

  build-system = [ setuptools ];

  # Package has a runtime dependency on 'pycrc16' but we provide 'crc16'
  # They provide the same crc16 module
  pythonRemoveDeps = [ "pycrc16" ];

  dependencies = [ crc16 ];

  # Package has no tests
  doCheck = false;

  meta = {
    description = "Python library for interfacing with Opple WiFi lights (legacy firmware support)";
    homepage = "https://github.com/tinysnake/python-oppleio-legacy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
