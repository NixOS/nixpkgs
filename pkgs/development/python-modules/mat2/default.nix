{
  lib,
  stdenv,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitLab,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "exiftool-13.25-compat.patch";
      url = "https://0xacab.org/jvoisin/mat2/-/commit/473903b70e1b269a6110242a9c098a10c18554e2.patch";
      hash = "sha256-vxxjAFwiTDlcTT3ZlfhOG4rlzBJS+LhLoA++8y2hEok=";
    })
    (fetchpatch {
      name = "fix-test-on-python313.patch";
      url = "https://0xacab.org/jvoisin/mat2/-/commit/f07344444d6d2f04a1f93e2954f4910b194bee0c.patch";
      hash = "sha256-y756sKkjGO11A2lrRsXAwWgupOZ00u0cDypvkbsiNbY=";
    })
    (fetchpatch {
      name = "fix-test-on-python312.patch";
      url = "https://0xacab.org/jvoisin/mat2/-/commit/7a8ea224bc327b8ee929379d577c74968ea1c352.patch";
      hash = "sha256-pPiYhoql5WhjhLKvd6y3OnvxORSbXIGCsZMc7UH3i1Q=";
    })
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

  postInstall = ''
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
