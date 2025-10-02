{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "vim-vint";
  version = "0.3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Vimjas";
    repo = "vint";
    tag = "v${version}";
    hash = "sha256-A0yXDkB/b9kEEXSoLeqVdmdm4p2PYL2QHqbF4FgAn30=";
  };

  patches = [
    # Otherwise, the following warning appears each time the binary is run:
    # UserWarning: pkg_resources is deprecated as an API.
    # This leads the `test/acceptance/test_cli.py::TestCLI::*` tests to fail
    (replaceVars ./remove-pkg-resources.patch {
      inherit version;
    })
  ];

  postPatch = ''
    substituteInPlace \
      test/acceptance/test_cli.py \
      test/acceptance/test_cli_vital.py \
      --replace-fail \
        "cmd = ['bin/vint'" \
        "cmd = ['$out/bin/vint'"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ansicolor
    chardet
    pyyaml
  ];

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
  ]);
  versionCheckProgramArg = "--version";

  meta = {
    description = "Fast and Highly Extensible Vim script Language Lint implemented by Python";
    homepage = "https://github.com/Kuniwak/vint";
    license = lib.licenses.mit;
    mainProgram = "vint";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
