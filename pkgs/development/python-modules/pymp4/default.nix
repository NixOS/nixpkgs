{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  construct,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymp4";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beardypig";
    repo = "pymp4";
    tag = "v${version}";
    hash = "sha256-gX9ovkA5+siYXmZ+StyQHRKrqS0NkKw0c/0SeUFcOqU=";
  };

  pythonRelaxDeps = [ "construct" ];

  build-system = [ poetry-core ];

  dependencies = [ construct ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;

  meta = {
    description = "Python library for parsing and manipulating MP4 files";
    homepage = "https://github.com/beardypig/pymp4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bdim404 ];
  };
}
