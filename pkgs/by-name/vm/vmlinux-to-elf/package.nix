{
  fetchFromGitHub,
  gobject-introspection,
  gtk4,
  lib,
  libadwaita,
  python3Packages,
  withGui ? false,
  wrapGAppsHook4,
}:
python3Packages.buildPythonApplication (finalAttrs: rec {
  pname = "vmlinux-to-elf";
  version = "1.3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "vmlinux-to-elf";
    rev = version;
    hash = "sha256-6sA2cI9SGd77pLr+0g09ffqnOgbkdd+651ES+c24upw=";
  };

  build-system = with python3Packages; [
    setuptools-scm
  ];

  nativeBuildInputs =
    (with python3Packages; [
      pythonRelaxDepsHook
    ])
    ++ lib.optionals withGui [
      wrapGAppsHook4
      gobject-introspection
    ];

  buildInputs = lib.optionals withGui [
    gtk4
    libadwaita
  ];

  __structuredAttrs = true;

  pythonRelaxDeps = [ "pygobject" ];

  dependencies =
    with python3Packages;
    [
      peewee_4
      zstandard
      lz4
      minilzo
    ]
    ++ lib.optionals withGui optional-dependencies.gui;

  optional-dependencies.gui = with python3Packages; [
    pygobject3
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postInstall = lib.optionalString (!withGui) ''
    rm -f $out/bin/vmlinux-to-elf-gui
  '';

  meta = {
    homepage = "https://github.com/marin-m/vmlinux-to-elf";
    description = "Converts a vmlinux/vmlinuz/bzImage/zImage kernel image to an ELF file";
    mainProgram = "vmlinux-to-elf";

    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
})
