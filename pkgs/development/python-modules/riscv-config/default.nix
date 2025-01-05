{
  lib,
  buildPythonPackage,
  cerberus,
  fetchFromGitHub,
  pythonOlder,
  pyyaml,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "riscv-config";
  version = "3.18.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "riscv-config";
    tag = version;
    hash = "sha256-eaHi6ezgU8gQYH97gCS2TzEzIP3F4zfn7uiA/To2Gmc=";
  };

  pythonRelaxDeps = [ "pyyaml" ];

  build-system = [ setuptools ];

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
