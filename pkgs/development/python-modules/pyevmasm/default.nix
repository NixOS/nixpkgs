{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyevmasm";
  version = "0.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "pyevmasm";
    rev = version;
    hash = "sha256-ChsacCkFv9b59FUnjgFtok+Q7kQpy8IlyL9/3MAHmIw=";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Ethereum Virtual Machine (EVM) assembler and disassembler";
    mainProgram = "evmasm";
    homepage = "https://github.com/crytic/pyevmasm";
    changelog = "https://github.com/crytic/pyevmasm/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arturcygan ];
  };
}
