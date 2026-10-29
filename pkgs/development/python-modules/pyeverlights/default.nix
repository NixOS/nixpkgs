{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyeverlights";
  version = "0.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "joncar";
    repo = "pyeverlights";
    rev = finalAttrs.version;
    hash = "sha256-oF5zEylShVTrZd5V0mMhqnC/43HEWYcObt4jOUbCt5s=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "pyeverlights" ];

  meta = {
    description = "Python module for interfacing with an EverLights control box";
    homepage = "https://github.com/joncar/pyeverlights";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
