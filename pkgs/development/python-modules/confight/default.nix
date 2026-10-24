{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "confight";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Avature";
    repo = "confight";
    tag = version;
    hash = "sha256-3tsTVCtnFk9qNv3oGg96OKoRIke0Q//pW3iZAdh1g4s=";
  };

  build-system = [ setuptools ];

  dependencies = [ toml ];

  pythonImportsCheck = [ "confight" ];

  doCheck = false;

  meta = {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/Avature/confight";
    changelog = "https://github.com/Avature/confight/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "confight";
  };
}
