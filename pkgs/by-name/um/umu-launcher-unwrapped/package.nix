{
  bash,
  cargo,
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3Packages,
  rustPlatform,
  scdoc,
  writableTmpDirAsHomeHook,
  withTruststore ? true,
  withDeltaUpdates ? true,
}:
python3Packages.buildPythonPackage rec {
  pname = "umu-launcher-unwrapped";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "Open-Wine-Components";
    repo = "umu-launcher";
    tag = version;
    hash = "sha256-G8UZvQ/pidh93FSsYq1dY0FTESWbksKAd9OU5Sxvv4I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-qGkEc4VPShMMNgSB4JmSf7Mq4jEOxEK+BqlR680ZO9k=";
  };

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    python3Packages.pytestCheckHook
  ];

  nativeBuildInputs = [
    cargo
    python3Packages.build
    python3Packages.installer
    python3Packages.hatchling
    python3Packages.hatch-vcs
    rustPlatform.cargoSetupHook
    scdoc
  ];

  pythonPath =
    with python3Packages;
    [
      pyzstd
      urllib3
      xlib
    ]
    ++ lib.optionals withTruststore [
      truststore
    ]
    ++ lib.optionals withDeltaUpdates [
      cbor2
      xxhash
    ];

  pyproject = false;
  configureScript = "./configure.sh";

  configureFlags = [
    "--use-system-pyzstd"
    "--use-system-urllib"
  ];

  makeFlags = [
    "PYTHONDIR=$(PREFIX)/${python3Packages.python.sitePackages}"
    "PYTHON_INTERPRETER=${lib.getExe python3Packages.python}"
    # Override RELEASEDIR to avoid running `git describe`
    "RELEASEDIR=${pname}-${version}"
    "SHELL_INTERPRETER=${lib.getExe bash}"
  ];

  disabledTests = [
    # Broken? Asserts that $STEAM_RUNTIME_LIBRARY_PATH is non-empty
    # Fails with AssertionError: '' is not true : Expected two elements in STEAM_RUNTIME_LIBRARY_PATHS
    "test_game_drive_empty"
    "test_game_drive_libpath_empty"

    # Broken? Tests parse_args with no options (./umu_run.py)
    # Fails with AssertionError: SystemExit not raised
    "test_parse_args_noopts"
  ];

  passthru.updateScript = nix-update-script { };

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
