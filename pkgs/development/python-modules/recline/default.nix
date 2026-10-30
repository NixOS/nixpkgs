{
  argcomplete,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  lib,
  poetry-core,
  pudb,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "recline";
  version = "2026.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    tag = "v${finalAttrs.version}.1";
    hash = "sha256-DQSLsMGS/YxchR4OfZGX2iPg7cqIJEoAScxYjKxOTFI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    argcomplete
    docstring-parser
  ];

  nativeCheckInputs = [
    pudb
    pytestCheckHook
  ];

  pythonImportsCheck = [ "recline" ];

  meta = {
    description = "This library helps you quickly implement an interactive command-based application";
    homepage = "https://github.com/NetApp/recline";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
