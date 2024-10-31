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
    repo = pname;
    rev = version;
    sha256 = "134q0z0dqzxzr0jw5jr98kp90kx2dl0qw9smykwxdgq555q1l6qa";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Ethereum Virtual Machine (EVM) assembler and disassembler";
    mainProgram = "evmasm";
    homepage = "https://github.com/crytic/pyevmasm";
    changelog = "https://github.com/crytic/pyevmasm/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arturcygan ];
  };
}
