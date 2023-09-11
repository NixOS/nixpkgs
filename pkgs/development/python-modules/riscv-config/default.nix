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
  version = "3.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-SnUt6bsTEC7abdQr0nWyNOAJbW64B1K3yy1McfkdxAc=";
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
    homepage = "https://github.com/riscv/riscv-config";
    changelog = "https://github.com/riscv-software-src/riscv-config/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
