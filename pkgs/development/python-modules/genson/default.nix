{
  buildPythonPackage,
  coverage,
  fetchFromGitHub,
  jsonschema,
  lib,
  pytestCheckHook,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "genson";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wolverdude";
    repo = "GenSON";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bb2PRuZuj/yotb78MbLgVwi4Fz7hbnXJmoXTe4kg43k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "genson" ];

  meta = {
    description = "GenSON a JSON Schema generator built in Python";
    homepage = "https://github.com/wolverdude/GenSON";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "genson";
  };
}
