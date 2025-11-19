{
  lib,
  stdenv,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,
  exiftool,
  ffmpeg,
  setuptools,
  wrapGAppsHook3,
  gdk-pixbuf,
  gnome,
  gobject-introspection,
  librsvg,
  poppler_gi,
  webp-pixbuf-loader,
  mutagen,
  pygobject3,
  pycairo,
  dolphinIntegration ? false,
  kdePackages,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "mat2";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = "mat2";
    tag = version;
    hash = "sha256-JTt2/PuSxOXXHUuRP42y8jxw09mNMMz1piJM4ldnjq0=";
  };

  patches = [
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
    (fetchpatch {
      name = "fix-test_html.patch";
      url = "https://github.com/jvoisin/mat2/commit/00b4f110711754496932c59d5af3c0b2ed694484.patch";
      hash = "sha256-5h/nM1dK8HmYtoIBVGOvUegMFBpGxcfpn5O6QrjLi9M=";
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
    poppler_gi
  ];

  dependencies = [
    mutagen
    pygobject3
    pycairo
  ];

  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"

    install -Dm 444 data/mat2.svg -t "$out/share/icons/hicolor/scalable/apps"
    install -Dm 444 doc/mat2.1 -t "$out/share/man/man1"
  ''
  + lib.optionalString dolphinIntegration ''
    install -Dm 444 dolphin/mat2.desktop -t "$out/share/kservices5/ServiceMenus"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Handy tool to trash your metadata";
    homepage = "https://github.com/jvoisin/mat2";
    changelog = "https://github.com/jvoisin/mat2/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "mat2";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
