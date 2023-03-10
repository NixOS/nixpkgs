{ buildPythonPackage
, fetchFromGitHub
, lib
, click
, colorlog
, gitpython
, pyelftools
, pytablewriter
, pytest
, pyyaml
, ruamel-yaml
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

  postPatch = "substituteInPlace riscv_isac/requirements.txt --replace 'pyelftools==0.26' pyelftools";

  propagatedBuildInputs = [
    click
    colorlog
    gitpython
    pyelftools
    pytablewriter
    pytest
    pyyaml
    ruamel-yaml
  ];

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-isac";
    description = "An ISA coverage extraction tool";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
