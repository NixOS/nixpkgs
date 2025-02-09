{
  lib,
  stdenv,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitLab,
  replaceVars,
  bubblewrap,
  exiftool,
  ffmpeg,
  setuptools,
  wrapGAppsHook3,
  gdk-pixbuf,
  gobject-introspection,
  librsvg,
  poppler_gi,
  mutagen,
  pygobject3,
  pycairo,
  dolphinIntegration ? false,
  kdePackages,
}:

buildPythonPackage rec {
  pname = "mat2";
  version = "0.13.5";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "0xacab.org";
    owner = "jvoisin";
    repo = "mat2";
    tag = version;
    hash = "sha256-ivFgH/88DBucZRaO/OMsLlwJCjv/VQXb6AiKWhZ8XH0=";
  };

  patches =
    [
      # hardcode paths to some binaries
      (replaceVars ./paths.patch {
        exiftool = lib.getExe exiftool;
        ffmpeg = lib.getExe ffmpeg;
        kdialog = if dolphinIntegration then lib.getExe kdePackages.kdialog else null;
        # replaced in postPatch
        mat2 = null;
        mat2svg = null;
      })
      # the executable shouldn't be called .mat2-wrapped
      ./executable-name.patch
      # hardcode path to mat2 executable
      ./tests.patch
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      (replaceVars ./bubblewrap-path.patch {
        bwrap = lib.getExe bubblewrap;
      })
    ];

  postPatch = ''
    substituteInPlace dolphin/mat2.desktop \
      --replace "@mat2@" "$out/bin/mat2" \
      --replace "@mat2svg@" "$out/share/icons/hicolor/scalable/apps/mat2.svg"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
    poppler_gi
  ];

  dependencies = [
    mutagen
    pygobject3
    pycairo
  ];

  postInstall =
    ''
      install -Dm 444 data/mat2.svg -t "$out/share/icons/hicolor/scalable/apps"
      install -Dm 444 doc/mat2.1 -t "$out/share/man/man1"
    ''
    + lib.optionalString dolphinIntegration ''
      install -Dm 444 dolphin/mat2.desktop -t "$out/share/kservices5/ServiceMenus"
    '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Handy tool to trash your metadata";
    homepage = "https://0xacab.org/jvoisin/mat2";
    changelog = "https://0xacab.org/jvoisin/mat2/-/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    mainProgram = "mat2";
    maintainers = with maintainers; [ dotlambda ];
  };
}
