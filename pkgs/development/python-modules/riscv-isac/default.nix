{ buildPythonPackage
, click
, colorlog
, gitpython
, pyelftools
, pytablewriter
, pytest
, pyyaml
, ruamel-yaml

, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "riscv-isac";
  version = "0.16.1";
  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = version;
    hash = "sha256-Krjr9bvpoOeNfMbYj/QbJ+Y+AVLjwrzj8KKMUXCfnMA=";
  };
  patches = [ ./pyelftools-version.patch ];
  propagatedBuildInputs = [ click colorlog gitpython pyelftools pytablewriter pytest pyyaml ruamel-yaml ];

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-isac";
    description = "riscv-isac is an ISA coverage extraction tool";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
