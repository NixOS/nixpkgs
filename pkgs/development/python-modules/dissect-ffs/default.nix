{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-ffs";
  version = "3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ffs";
    tag = version;
    hash = "sha256-U/Roo1+viW/Fnvt+QV6Rt6YvOSyOSGg5c2ZaHfaFQLQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.ffs" ];

  meta = {
    description = "Dissect module implementing a parser for the FFS file system";
    homepage = "https://github.com/fox-it/dissect.ffs";
    changelog = "https://github.com/fox-it/dissect.ffs/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
