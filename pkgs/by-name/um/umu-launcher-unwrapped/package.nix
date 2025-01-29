{
  python3Packages,
  fetchFromGitHub,
  lib,
  bash,
  hatch,
  scdoc,
  replaceVars,
  fetchpatch2,
}:
python3Packages.buildPythonPackage rec {
  pname = "umu-launcher-unwrapped";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "Open-Wine-Components";
    repo = "umu-launcher";
    tag = version;
    hash = "sha256-TOsVK6o2V8D7CLzVOkLs8AClrZmlVQTfeii32ZIQCu4=";
  };

  # Both patches can be safely removed with the next release
  patches = [
    # Patch to avoid running `git describe`
    # Fixed by https://github.com/Open-Wine-Components/umu-launcher/pull/289 upstream
    (replaceVars ./no-umu-version-json.patch { inherit version; })
    # Patch to use PREFIX in the installer call
    (fetchpatch2 {
      url = "https://github.com/Open-Wine-Components/umu-launcher/commit/602a2f84a05a63f7b1b1c4d8ca85d99fdaec2cd2.diff";
      hash = "sha256-BMinTXr926V3HlzHHabxHKvy8quEvxsZKu1hoTGQT00=";
    })
  ];

  nativeBuildInputs = [
    python3Packages.build
    hatch
    scdoc
    python3Packages.installer
  ];

  pythonPath = [
    python3Packages.filelock
    python3Packages.xlib
  ];

  pyproject = false;
  configureScript = "./configure.sh";

  makeFlags = [
    "PYTHONDIR=$(PREFIX)/${python3Packages.python.sitePackages}"
    "PYTHON_INTERPRETER=${lib.getExe python3Packages.python}"
    # Override RELEASEDIR to avoid running `git describe`
    "RELEASEDIR=${pname}-${version}"
    "SHELL_INTERPRETER=${lib.getExe bash}"
  ];

  meta = {
    description = "Unified launcher for Windows games on Linux using the Steam Linux Runtime and Tools";
    changelog = "https://github.com/Open-Wine-Components/umu-launcher/releases/tag/${version}";
    homepage = "https://github.com/Open-Wine-Components/umu-launcher";
    license = lib.licenses.gpl3;
    mainProgram = "umu-run";
    maintainers = with lib.maintainers; [
      diniamo
      MattSturgeon
      fuzen
    ];
    platforms = lib.platforms.linux;
  };
}
