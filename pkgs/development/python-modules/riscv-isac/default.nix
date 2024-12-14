{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  colorlog,
  gitpython,
  pluggy,
  pyelftools,
  pytablewriter,
  pytestCheckHook,
  pyyaml,
  ruamel-yaml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "riscv-isac";
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7CWUyYwzynFq/Qk5SzQB+ljsVVI98kPPDT63Emhqihw=";
  };

  postPatch = ''
    substituteInPlace riscv_isac/requirements.txt \
      --replace "pyelftools==0.26" "pyelftools" \
      --replace "pytest" ""
  '';

  propagatedBuildInputs = [
    click
    colorlog
    gitpython
    pluggy
    pyelftools
    pytablewriter
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "riscv_isac" ];

  meta = with lib; {
    description = "ISA coverage extraction tool";
    mainProgram = "riscv_isac";
    homepage = "https://github.com/riscv/riscv-isac";
    changelog = "https://github.com/riscv-software-src/riscv-isac/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}
