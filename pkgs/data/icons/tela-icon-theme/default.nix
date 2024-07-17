{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  jdupes,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tela-icon-theme";
  version = "2024-04-19";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "tela-icon-theme";
    rev = version;
    hash = "sha256-Z1U0KJMnNNXL5fn3kPoZ2RZNi95T27/tnWVgR8kTj1o=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh
    mkdir -p $out/share/icons
    ./install.sh -a -d $out/share/icons
    jdupes -l -r $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "A flat colorful Design icon theme";
    homepage = "https://github.com/vinceliuice/tela-icon-theme";
    changelog = "https://github.com/vinceliuice/Tela-icon-theme/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    # darwin systems use case-insensitive filesystems that cause hash mismatches
    platforms = subtractLists platforms.darwin platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
