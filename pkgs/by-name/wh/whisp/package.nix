{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  wrapGAppsHook4,
  gobject-introspection,
  gettext,
  python3Packages,
  glib,
  gtk4,
  libadwaita,
  tesseract,
  withTesseractOCR ? true,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "whisp";
  version = "1.6.1";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "tanaybhomia";
    repo = "whisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z9RAS+KlvCrDIQhbjmHSKDI0LRmkuMMsky3w3Jdozrs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook4
    gobject-introspection
    gettext
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  dependencies =
    with python3Packages;
    (
      [ pygobject3 ]
      ++ lib.optionals withTesseractOCR [
        pytesseract
        pillow
      ]
    )
    ++ lib.optional withTesseractOCR tesseract;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
    "''${gappsWrapperArgs[@]}"
    ${lib.optionalString withTesseractOCR ''--prefix PATH : "${lib.makeBinPath [ tesseract ]}"''}
    )
  '';

  __structuredAttrs = true;

  meta = {
    description = "Scratchpad inspired by the 'anti-note' philosophy";
    longDescription = ''
      The Anti-Note for GNOME.
      A fluid, gesture-driven scratchpad designed for absolute speed.
    '';
    homepage = "https://tanaybhomia.github.io/Whisp/";
    changelog = "https://github.com/tanaybhomia/Whisp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    mainProgram = "whisp";
    maintainers = [
      lib.maintainers.luminarleaf
      lib.maintainers.theCapypara
    ];
    platforms = lib.platforms.linux;
  };
})
