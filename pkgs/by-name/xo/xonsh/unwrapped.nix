{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  ply,
  prompt-toolkit,
  pygments,

  addBinToPathHook,
  writableTmpDirAsHomeHook,
  gitMinimal,
  glibcLocales,
  pip,
  pyte,
  pytest-mock,
  pytest-subprocess,
  pytestCheckHook,
  requests,

  man,
  util-linux,

  coreutils,

  nix-update-script,
  python,
  callPackage,
}:

buildPythonPackage rec {
  pname = "xonsh";
  version = "0.22.7";
  pyproject = true;

  # PyPI package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    tag = version;
    hash = "sha256-2Gvd7jOKhouorE8wH4FaWlaw8y1h4uf/Z+sYWO96Vps=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ply
    prompt-toolkit
    pygments
  ];

  nativeCheckInputs = [
    addBinToPathHook
    writableTmpDirAsHomeHook
    gitMinimal
    glibcLocales
    pip
    pyte
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    requests

    # required by test_man_completion
    man
    util-linux
  ];

  disabledTests = [
    # fails on sandbox
    "test_colorize_file"
    "test_xonsh_activator"

    # flaky tests
    "test_alias_stability"
    "test_alias_stability_exception"
    "test_complete_import"
    "test_script"
    "test_subproc_output_format"
  ];

  # https://github.com/NixOS/nixpkgs/issues/248978
  dontWrapPythonPrograms = true;

  env.LC_ALL = "en_US.UTF-8";

  postPatch = ''
    sed -i -e 's|/bin/ls|${lib.getExe' coreutils "ls"}|' tests/test_execer.py
    sed -i -e 's|SHELL=xonsh|SHELL=$out/bin/xonsh|' tests/test_integrations.py

    for script in tests/test_integrations.py scripts/xon.sh $(find -name "*.xsh"); do
      sed -i -e 's|/usr/bin/env|${lib.getExe' coreutils "env"}|' $script
    done
    patchShebangs .
  '';

  passthru = {
    inherit python;
    shellPath = "/bin/xonsh";
    wrapper = throw "The top-level xonsh package is now wrapped. Use it directly.";
    updateScript = nix-update-script { };
    xontribs = import ./xontribs { inherit callPackage; };
  };

  meta = {
    homepage = "https://xon.sh/";
    description = "Python-ish, BASHwards-compatible shell";
    changelog = "https://github.com/xonsh/xonsh/raw/main/CHANGELOG.rst";
    license = with lib.licenses; [ bsd3 ];
    mainProgram = "xonsh";
    maintainers = with lib.maintainers; [ samlukeyes123 ];
  };
}
