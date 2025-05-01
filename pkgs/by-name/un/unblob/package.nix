{
  lib,
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

  pythonRelaxDeps = [ "rich" ];

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

  pytestFlagsArray =
    let
      # `disabledTests` swallows the parameters between square brackets
      disabled = [
        # https://github.com/tytso/e2fsprogs/issues/152
        "test_all_handlers[filesystem.extfs]"

        # Should be dropped after upgrading to next version
        # Needs https://github.com/onekey-sec/unblob/pull/1128/commits/c6af67f0c6f32fa01d7abbf495eb0293e9184438
        # Unfortunately patches touching LFS stored assets cannot be applied
        "test_all_handlers[filesystem.ubi.ubi]"
        "test_all_handlers[archive.dlink.encrpted_img]"
        "test_all_handlers[archive.dlink.shrs]"
      ];
    in
    [
      "--no-cov"
      "-k 'not ${lib.concatStringsSep " and not " disabled}'"
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
