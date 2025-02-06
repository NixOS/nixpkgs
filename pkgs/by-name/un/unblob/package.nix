{
  lib,
  fetchpatch,
  python3,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
  e2fsprogs,
  jefferson,
  lz4,
  lziprecover,
  lzop,
  p7zip,
  sasquatch,
  sasquatch-v4be,
  simg2img,
  ubi_reader,
  unar,
  zstd,
  versionCheckHook,
}:

let
  # These dependencies are only added to PATH
  runtimeDeps = [
    e2fsprogs
    jefferson
    lziprecover
    lzop
    p7zip
    sasquatch
    sasquatch-v4be
    ubi_reader
    simg2img
    unar
    zstd
    lz4
  ];
in
python3.pkgs.buildPythonApplication rec {
  pname = "unblob";
  version = "25.1.8";
  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob";
    tag = version;
    hash = "sha256-PGpJPAo9q52gQ3EGusYtDA2e0MG5kFClqCYPB2DvuMs=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  strictDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    arpy
    attrs
    click
    cryptography
    dissect-cstruct
    lark
    lief.py
    python3.pkgs.lz4 # shadowed by pkgs.lz4
    plotext
    pluggy
    pyfatfs
    pyperscan
    python-magic
    rarfile
    rich
    structlog
    treelib
    unblob-native
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  # These are runtime-only CLI dependencies, which are used through
  # their CLI interface
  pythonRemoveDeps = [
    "jefferson"
    "ubi-reader"
  ];

  pythonImportsCheck = [ "unblob" ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath runtimeDeps}"
  ];

  nativeCheckInputs =
    with python3.pkgs;
    [
      pytestCheckHook
      pytest-cov
      versionCheckHook
    ]
    ++ runtimeDeps;

  versionCheckProgramArg = "--version";

  pytestFlagsArray = [
    "--no-cov"
    # `disabledTests` swallows the parameters between square brackets
    # https://github.com/tytso/e2fsprogs/issues/152
    "-k 'not test_all_handlers[filesystem.extfs]'"
  ];

  passthru = {
    updateScript = gitUpdater { };
    # helpful to easily add these to a nix-shell environment
    inherit runtimeDeps;
  };

  meta = {
    description = "Extract files from any kind of container formats";
    homepage = "https://unblob.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "unblob";
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
