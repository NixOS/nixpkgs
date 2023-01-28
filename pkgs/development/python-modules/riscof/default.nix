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

  propagatedBuildInputs = [ riscv-isac riscv-config jinja2 ];
  GIT_PYTHON_GIT_EXECUTABLE = "${git}/bin/git";

  patches = [ ./make_writeable.patch ./gitpython-version.patch ];
  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "1.25.2";
    hash = "sha256-6jiKBGj4NN038/qq3ze+L0MYpQEEaN5xt4CTWu0i4qs=";
  };

  meta = with lib; {
    homepage = "https://github.com/riscv-software-src/riscof";
    description = "RISCOF is a RISC-V Architectural Test Framework";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
