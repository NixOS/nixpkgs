{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "4.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jodal";
    repo = "pykka";
    tag = "v${version}";
    hash = "sha256-61Dr8V2LILGNveVi6eD0OODXF/a8m8I5/H9MfyIr9Dg=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "pykka" ];

  meta = {
    homepage = "https://www.pykka.org/";
    description = "Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/releases/tag/${src.tag}";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
