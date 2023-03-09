{ buildPythonPackage
, fetchFromGitHub
, lib
, git
, riscv-isac
, riscv-config
, jinja2
}:

buildPythonPackage rec {
  pname = "riscof";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "1.25.2";
    hash = "sha256-6jiKBGj4NN038/qq3ze+L0MYpQEEaN5xt4CTWu0i4qs=";
  };

  postPatch = "substituteInPlace riscof/requirements.txt --replace 'GitPython==3.1.17' GitPython";

  propagatedBuildInputs = [ riscv-isac riscv-config jinja2 ];

  patches = [
    # riscof copies a template directory from the store, but breaks because it doesn't change permissions and expects it to be writeable
    ./make_writeable.patch
  ];

  meta = with lib; {
    homepage = "https://github.com/riscv-software-src/riscof";
    description = "RISC-V Architectural Test Framework";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
