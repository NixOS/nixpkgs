{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  qt6,
  copyDesktopItems,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vdu_controls";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitaltrails";
    repo = "vdu_controls";
    rev = "v${version}";
    hash = "sha256-aapODSWPB98I/ieUTXIO7nrd11VY9SmFpsVR1ketsZU=";
  };

  patches = [
    # Standardize installation with pypa/build. See:
    # https://github.com/digitaltrails/vdu_controls/pull/120
    (fetchpatch {
      url = "https://github.com/digitaltrails/vdu_controls/commit/ef2ed07398fc88ccc18a11da3cf5ea1500a03cb6.patch";
      hash = "sha256-W0Iv3RXQFnHAzaXHh6ZvGARN4ShsNgOhg9FTpbvnfLo=";
    })
  ];

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.sphinx
  ];
  # Replace FHS paths with out paths. Unfortunately it will be pretty hard to
  # change this behavior upstream, as they barely use any packaging system
  # whatsoever.
  preBuild = ''
    substituteInPlace vdu_controls.py \
        --replace-fail /usr/share/vdu_controls $out/share/vdu_controls
  '';

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    copyDesktopItems
    installShellFiles
  ];
  desktopItems = "vdu_controls.desktop";
  postInstall = ''
    install -Dm066 vdu_controls.png $out/share/icons/hicolor/256x256/apps/vdu_controls.png
    make -C docs man
    installManPage docs/_build/man/vdu_controls.1
    mkdir -p $out/share/vdu_controls
    cp -r icons $out/share/vdu_controls
    cp -r sample-scripts $out/share/vdu_controls
    cp -r translations $out/share/vdu_controls
  '';

  dependencies = [
    python3.pkgs.pyqt6
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "VDU controls - a control panel for monitor brightness/contrast";
    homepage = "https://github.com/digitaltrails/vdu_controls";
    license = lib.licenses.gpl3Only;
    mainProgram = "vdu_controls";
  };
}
