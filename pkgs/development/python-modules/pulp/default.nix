{
  lib,
  cbc,
  amply,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pulp";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "pulp";
    tag = version;
    hash = "sha256-b9qTJqSC8G3jxcqS4mkQ1gOLLab+YzYaNClRwD6I/hk=";
  };

  patches = [ ./cbc_path_fixes.patch ];

  postPatch = ''
    substituteInPlace pulp/apis/coin_api.py --subst-var-by "cbc" "${lib.getExe' cbc "cbc"}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    amply
    pyparsing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pulp" ];

  meta = {
    description = "Module to generate MPS or LP files";
    mainProgram = "pulptest";
    homepage = "https://github.com/coin-or/pulp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
