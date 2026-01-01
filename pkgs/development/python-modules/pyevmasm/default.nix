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
    sha256 = "134q0z0dqzxzr0jw5jr98kp90kx2dl0qw9smykwxdgq555q1l6qa";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Ethereum Virtual Machine (EVM) assembler and disassembler";
    mainProgram = "evmasm";
    homepage = "https://github.com/crytic/pyevmasm";
    changelog = "https://github.com/crytic/pyevmasm/releases/tag/${version}";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arturcygan ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ arturcygan ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
