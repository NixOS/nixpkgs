{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  jdupes,
  adwaita-icon-theme,
  libsForQt5,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tela-icon-theme";
  version = "2025-02-10";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "tela-icon-theme";
    rev = version;
    hash = "sha256-ufjKFlKJnmNwD2m1w+7JSBQij6ltxXWCpUEvVxECS98=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    libsForQt5.breeze-icons
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh
    mkdir -p $out/share/icons
    ./install.sh -a -d $out/share/icons
    jdupes -l -r $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flat colorful Design icon theme";
    homepage = "https://github.com/vinceliuice/tela-icon-theme";
    changelog = "https://github.com/vinceliuice/Tela-icon-theme/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    # darwin systems use case-insensitive filesystems that cause hash mismatches
    platforms = subtractLists platforms.darwin platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
