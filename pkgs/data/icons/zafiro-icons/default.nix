{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  breeze-icons,
  gnome-icon-theme,
  numix-icon-theme,
  numix-icon-theme-circle,
  hicolor-icon-theme,
  jdupes,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zafiro-icons";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = version;
    sha256 = "sha256-IbFnlUOSADYMNMfvRuRPndxcQbnV12BqMDb9bJRjnoU=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    hicolor-icon-theme
    # still missing parent icon themes: Surfn
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons

    for theme in Dark Light; do
      cp -a $theme $out/share/icons/Zafiro-icons-$theme

      # remove unneeded files
      rm $out/share/icons/Zafiro-icons-$theme/_config.yml

      # remove files with non-ascii characters in name
      # https://github.com/zayronxio/Zafiro-icons/issues/111
      rm $out/share/icons/Zafiro-icons-$theme/apps/scalable/βTORRENT.svg

      gtk-update-icon-cache $out/share/icons/Zafiro-icons-$theme
    done

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Icon pack flat with light colors";
    homepage = "https://github.com/zayronxio/Zafiro-icons";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
