{
  lib,
  aiohttp,
  bleak,
  buildPythonPackage,
  csrmesh,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "halohome";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nayaverdier";
    repo = "halohome";
    tag = finalAttrs.version;
    hash = "sha256-JOQ2q5lbdVTerXPt6QHBiTG9PzN9LiuLcN+XnOoyYjA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
    csrmesh
  ];

  pythonRelaxDeps = [ "bleak" ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "halohome" ];

  meta = {
    description = "Python library to control Eaton HALO Home Smart Lights";
    homepage = "https://github.com/nayaverdier/halohome";
    changelog = "https://github.com/nayaverdier/halohome/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
