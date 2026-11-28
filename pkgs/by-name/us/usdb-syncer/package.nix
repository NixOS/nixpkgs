{
  lib,
  python3Packages,
  fetchFromGitHub,
  deno,
  ffmpeg,
  qt6,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "usdb-syncer";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bohning";
    repo = "usdb_syncer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9u4FqWadJqPhlRpeXe5XIjTD1PEOSZCS/d1fy1mamIU=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3Packages; [
    attrs
    beautifulsoup4
    diff-match-patch
    fake-useragent
    ffmpeg-normalize
    filetype
    flask
    keyring
    lxml
    mutagen
    numpy
    packaging
    pillow
    platformdirs
    pyside6
    qrcode
    reportlab
    requests
    send2trash
    sounddevice
    soundfile
    unidecode
    yt-dlp
  ];

  nativeBuildInputs = [
    qt6.qtbase
    qt6.wrapQtAppsHook
  ];

  # Make external runtime tools available when the app is launched.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      deno
      ffmpeg
    ])
  ];

  # Deno is an external executable, not a Python module.
  pythonRemoveDeps = [ "deno" ];

  # Nixpkgs provides newer versions than the upstream constraints
  # currently allow. The newer versions have been tested and work correctly,
  # so the upstream restrictions are unnecessarily strict here.
  pythonRelaxDeps = [
    "pyside6"
    "soundfile"
  ];

  pythonImportsCheck = [
    "usdb_syncer"
    "usdb_syncer.gui"
    "usdb_syncer.gui.forms.ExternalDepsDialog"
  ];

  # Generate Python modules from Qt Designer UI and resource files.
  preBuild = ''
    FORMS="src/usdb_syncer/gui/forms"
    RESOURCES="src/usdb_syncer/gui/resources/qt"

    UIC="${qt6.qtbase}/libexec/uic"
    RCC="${qt6.qtbase}/libexec/rcc"

    if [ ! -x "$UIC" ] || [ ! -x "$RCC" ]; then
      echo "ERROR: Qt UI/resource generators not found"
      exit 1
    fi

    while IFS= read -r -d "" ui; do
      output="''${ui%.ui}.py"
      echo "Generating $output"
      "$UIC" -g python --from-imports "$ui" -o "$output"
    done < <(find "$FORMS" -name '*.ui' -print0)

    qrc=$(find "$RESOURCES" -name '*.qrc' -print -quit)

    if [ -z "$qrc" ]; then
      echo "ERROR: No Qt resource file found under $RESOURCES"
      exit 1
    fi

    echo "Generating $FORMS/resources_rc.py from $qrc"
    "$RCC" -g python "$qrc" -o "$FORMS/resources_rc.py"
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    defusedxml
  ];

  disabledTestPaths = [
    # Inspects icon files in the source tree, which the wheel excludes,
    # so it can't pass against the installed package.
    "tests/unit/test_icons.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Fetches the remote config from raw.githubusercontent.com, which fails in the sandbox
    "test_discord_webhook_url"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An app to download and synchronize UltraStar songs hosted on USDB.";
    homepage = "https://github.com/bohning/usdb_syncer";
    changelog = "https://github.com/bohning/usdb_syncer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Only # USDB Syncer
      cc-by-30 # Default Icons
      asl20 # Material Design Icons
    ];
    maintainers = with lib.maintainers; [
      jocraft2010
    ];
    mainProgram = "usdb_syncer";
  };
})
