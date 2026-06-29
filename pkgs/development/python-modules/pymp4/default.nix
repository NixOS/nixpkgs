{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  construct,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pymp4";
  version = "1.4.0-unstable-2023-08-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devine-dl";
    repo = "pymp4";
    rev = "33dc5d620f361cb49d713b60dcb2686ab8696f91";
    hash = "sha256-tPIbehjYHg5+S62sorsWow+u/eBkqJYf6xMI8q4vEgY=";
  };

  pythonRelaxDeps = [ "construct" ];

  build-system = [ poetry-core ];

  dependencies = [ construct ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false;

  meta = {
    description = "Python library for parsing and manipulating MP4 files";
    homepage = "https://github.com/beardypig/pymp4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bdim404 ];
  };
}
