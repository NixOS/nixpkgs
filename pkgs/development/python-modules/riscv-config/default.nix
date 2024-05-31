{
  lib,
  buildPythonPackage,
  cerberus,
  fetchFromGitHub,
  pythonOlder,
  pyyaml,
  ruamel-yaml,
  setuptools,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "riscv-config";
  version = "3.18.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "riscv-config";
    rev = "refs/tags/${version}";
    hash = "sha256-ADmf7EN3D+8isZRFx6WRMYq91YHunGavuwy3a3M3gCc=";
  };

  pythonRelaxDeps = [ "pyyaml" ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    cerberus
    pyyaml
    ruamel-yaml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "riscv_config" ];

  meta = with lib; {
    description = "RISC-V configuration validator";
    homepage = "https://github.com/riscv/riscv-config";
    changelog = "https://github.com/riscv-software-src/riscv-config/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ genericnerdyusername ];
    mainProgram = "riscv-config";
  };
}
