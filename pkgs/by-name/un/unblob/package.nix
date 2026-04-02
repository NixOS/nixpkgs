{
  lib,
  libiconv,
  python3,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  stdenvNoCC,
  e2fsprogs,
  erofs-utils,
  jefferson,
  lz4,
  lziprecover,
  lzop,
  p7zip,
  partclone,
  sasquatch,
  sasquatch-v4be,
  simg2img,
  ubi_reader,
  unar,
  upx,
  zstd,
  versionCheckHook,
}:

let
  # These dependencies are only added to PATH
  runtimeDeps = [
    e2fsprogs
    erofs-utils
    jefferson
    lziprecover
    lzop
    p7zip
    sasquatch
    sasquatch-v4be
    ubi_reader
    simg2img
    unar
    upx
    zstd
    lz4
  ]
  ++ lib.optional stdenvNoCC.isLinux partclone;
in
python3.pkgs.buildPythonApplication rec {
  pname = "unblob";
  version = "26.3.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob";
    tag = version;
    hash = "sha256-wYWuKvxAagctlmdO5Fi9/WzfJ4zkDgfXejgDTJPHsTI=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-wjN4QPOUYFWWYMWL9aAgGqEucM7q+H6YyoS9Mv2dpp4=";
  };

  strictDeps = true;

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [ libiconv ];

  dependencies = with python3.pkgs; [
    arpy
    attrs
    click
    cryptography
    dissect-cstruct
    lark
    lief.py
    lzallright
    python3.pkgs.lz4 # shadowed by pkgs.lz4
    plotext
    pluggy
    pydantic
    pyfatfs
    pymdown-extensions
    pyperscan
    python-magic
    pyzstd
    rarfile
    rich
    structlog
    treelib
  ];

  nativeBuildInputs = with rustPlatform; [
    makeWrapper
    maturinBuildHook
    cargoSetupHook
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
      pexpect
      psutil
      pytest-cov-stub
      pytestCheckHook
      versionCheckHook
    ]
    ++ runtimeDeps;

  pytestFlags = [
    "--with-e2e" # Not that slow: increases test time by ~5s
  ];

  disabledTests = [
    # https://github.com/tytso/e2fsprogs/issues/152
    "test_all_handlers[filesystem.extfs]"
    # regression in erofs-utils 1.9 https://github.com/onekey-sec/unblob/commit/c7c9f20dd871a5694d41a95ca3041eb0c98e257a
    "test_all_handlers[filesystem.android.erofs]"
  ];

  passthru = {
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
