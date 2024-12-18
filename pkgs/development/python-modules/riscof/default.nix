{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  jinja2,
  pythonOlder,
  riscv-config,
  riscv-isac,
}:

buildPythonPackage rec {
  pname = "riscof";
  version = "1.25.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ToI2xI0fvnDR+hJ++T4ss5X3gc4G6Cj1uJHx0m2X7GY=";
  };

  patches = [
    # riscof copies a template directory from the store, but breaks because it
    # doesn't change permissions and expects it to be writeable
    ./make_writeable.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "import pip" ""
    substituteInPlace riscof/requirements.txt \
      --replace "GitPython==3.1.17" "GitPython"
  '';

  propagatedBuildInputs = [
    riscv-isac
    riscv-config
    jinja2
  ];

  pythonImportsCheck = [ "riscof" ];

  # No unitests available
  doCheck = false;

  meta = with lib; {
    description = "RISC-V Architectural Test Framework";
    mainProgram = "riscof";
    homepage = "https://github.com/riscv-software-src/riscof";
    changelog = "https://github.com/riscv-software-src/riscof/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
