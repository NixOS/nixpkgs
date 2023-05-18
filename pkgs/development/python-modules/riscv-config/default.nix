{ buildPythonPackage
, fetchFromGitHub
, lib
, cerberus
, pyyaml
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "riscv-config";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-K7W6yyqy/2c4WHyOojuvw2P/v7bND5K6WFfTujkofBw=";
  };

  propagatedBuildInputs = [ cerberus pyyaml ruamel-yaml ];

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-config";
    description = "RISC-V configuration validator";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
