{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "vim-vint";
  version = "0.3.21";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Vimjas";
    repo = "vint";
    tag = "v${version}";
    hash = "sha256-A0yXDkB/b9kEEXSoLeqVdmdm4p2PYL2QHqbF4FgAn30=";
  };

  # For python 3.5 > version > 2.7 , a nested dependency (pythonPackages.hypothesis) fails.
  disabled = !pythonAtLeast "3.5";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];
  propagatedBuildInputs = [
    ansicolor
    chardet
    pyyaml
    setuptools
  ];

  preCheck = ''
    substituteInPlace \
      test/acceptance/test_cli.py \
      test/acceptance/test_cli_vital.py \
      --replace-fail \
        "cmd = ['bin/vint'" \
        "cmd = ['$out/bin/vint'"
  '';

  meta = with lib; {
    description = "Fast and Highly Extensible Vim script Language Lint implemented by Python";
    homepage = "https://github.com/Kuniwak/vint";
    license = licenses.mit;
    mainProgram = "vint";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
