{
  lib,
  aiohttp,
  bleak,
  buildPythonPackage,
  csrmesh,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "halohome";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nayaverdier";
    repo = "halohome";
    rev = "refs/tags/${version}";
    hash = "sha256-JOQ2q5lbdVTerXPt6QHBiTG9PzN9LiuLcN+XnOoyYjA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
    csrmesh
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "halohome" ];

  meta = with lib; {
    description = "Python library to control Eaton HALO Home Smart Lights";
    homepage = "https://github.com/nayaverdier/halohome";
    changelog = "https://github.com/nayaverdier/halohome/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
