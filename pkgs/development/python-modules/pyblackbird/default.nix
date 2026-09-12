{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  serialx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyblackbird";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koolsb";
    repo = "pyblackbird";
    tag = version;
    hash = "sha256-0XkHSRLHKAaem9qMr4Qac1YA2txci/SDgA0kfXMeiM0=";
  };

  build-system = [ setuptools ];

  dependencies = [ serialx ];

  # Test setup try to create a serial port
  doCheck = false;

  pythonImportsCheck = [ "pyblackbird" ];

  meta = {
    description = "Python implementation for Monoprice Blackbird units";
    homepage = "https://github.com/koolsb/pyblackbird";
    changelog = "https://github.com/koolsb/pyblackbird/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
