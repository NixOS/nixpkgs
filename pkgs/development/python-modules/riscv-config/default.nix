{ lib
, buildPythonPackage
, cerberus
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pyyaml
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "riscv-config";
  version = "3.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-M36xS9rBnCPHWmHvAA6qC9J21K/zIjgsqEyhApJDKrE=";
  };

  propagatedBuildInputs = [
    cerberus
    pyyaml
    ruamel-yaml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "riscv_config"
  ];

  meta = with lib; {
    description = "RISC-V configuration validator";
    mainProgram = "riscv-config";
    homepage = "https://github.com/riscv/riscv-config";
    changelog = "https://github.com/riscv-software-src/riscv-config/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
