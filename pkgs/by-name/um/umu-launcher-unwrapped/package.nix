{
  bash,
  cargo,
  fetchFromGitHub,
  hatch,
  lib,
  python3Packages,
  rustPlatform,
  scdoc,
  withTruststore ? true,
  withDeltaUpdates ? true,
}:
python3Packages.buildPythonPackage rec {
  pname = "umu-launcher-unwrapped";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Open-Wine-Components";
    repo = "umu-launcher";
    tag = version;
    hash = "sha256-bZ6Ywc524NrapkFrwFiWbqmVe1j0hunEH9YKrYQ8R2E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-nU4xZn9NPd7NgexiaNYLdo4BCbH98duZ07XYeUiceP0=";
  };

  nativeBuildInputs = [
    cargo
    hatch
    python3Packages.build
    python3Packages.installer
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
