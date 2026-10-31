{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  standard-telnetlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynut2";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "python-nut2";
    rev = version;
    hash = "sha256-Hd4WpPp9AtPMNozyeN2p/Rs2DwxUa6DH4c81m12w59E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    standard-telnetlib
  ];

  pythonImportsCheck = [ "pynut2.nut2" ];

  # tests are unmaintained and broken
  doCheck = false;

  meta = {
    description = "API overhaul of PyNUT, a Python library to allow communication with NUT (Network UPS Tools) servers";
    homepage = "https://github.com/mezz64/python-nut2";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.luker ];
  };
}
