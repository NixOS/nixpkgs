{ buildPythonPackage
, fetchFromGitHub
, lib
, cerberus
, pyyaml
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "riscv-config";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = version;
    hash = "sha256-HKmHrvOF4OOzoILrBJG46UOKow5gRxMcXXiI6f34dPc=";
  };

  propagatedBuildInputs = [ cerberus pyyaml ruamel-yaml ];

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-config";
    description = "RISC-V configuration validator";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
