{
  lib,
  callPackage,
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
  version = "24.9.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob";
    rev = version;
    hash = "sha256-r5UGoCOzYO/v7cAkbhOmeX7caspues/k/gokuzh1wsU=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  strictDeps = true;
  buildInputs = with python3.pkgs; [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
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

  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace-fail jefferson "# jefferson" \
        --replace-fail ubi-reader "# ubi-reader"
  '';

  pythonImportsCheck = [ "unblob" ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath runtimeDeps}"
  ];

  doCheck = false;
  passthru = {
    tests.pytest = callPackage ./tests.nix { };
    updateScript = gitUpdater { };
    # helpful to easily add these to a nix-shell environment
    inherit runtimeDeps;
  };

  meta = {
    description = "Extract files from any kind of container formats";
    homepage = "https://unblob.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
