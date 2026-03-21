{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pyserial-asyncio,
}:

buildPythonPackage rec {
  pname = "pyblackbird";
  version = "0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "koolsb";
    repo = "pyblackbird";
    tag = version;
    hash = "sha256-+ehzrr+RrwFKOOuxBq3+mwnuMPxZFV4QTZG1IRgsbLc=";
  };

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
  ];

  # Test setup try to create a serial port
  doCheck = false;

  pythonImportsCheck = [ "pyblackbird" ];

  meta = {
    description = "Python implementation for Monoprice Blackbird units";
    homepage = "https://github.com/koolsb/pyblackbird";
    changelog = "https://github.com/koolsb/pyblackbird/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
