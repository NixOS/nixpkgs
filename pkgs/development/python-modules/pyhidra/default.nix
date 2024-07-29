{ lib
, python3
, fetchFromGitHub
, ghidra
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pyhidra";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dod-cyber-crime-center";
    repo = "pyhidra";
    rev = version;
    hash = "sha256-YAtQ0jN6+EqKNLDGgvFUf3lB5FR/dDEQ+g/BfUyRhRo=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.jpype1
    python3.pkgs.tkinter
  ];

  makeWrapperArgs = [
    "--set GHIDRA_INSTALL_DIR ${ghidra}/lib/ghidra"
  ];

  pythonImportsCheck = [ "pyhidra" ];

  meta = with lib; {
    description = "A Python library that provides direct access to the Ghidra API within a native CPython interpreter using jpype";
    homepage = "https://github.com/dod-cyber-crime-center/pyhidra";
    changelog = "https://github.com/dod-cyber-crime-center/pyhidra/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
  };
}
