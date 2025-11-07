{
  lib,
  stdenvNoCC,
  fetchurl,
  gtk-engine-murrine,
  jdupes,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.25";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-obsidian-2/releases/download/v${version}/obsidian-2-theme.tar.xz";
    sha256 = "sha256-Hajz2bFcsi+9kSjxuZ6Jav8t7S6trDUF5yJivw+Vypw=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    jdupes
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Obsidian-2* $out/share/themes
    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/madmaxms/theme-obsidian-2";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Gnome theme based upon Adwaita-Maia dark skin";
    homepage = "https://github.com/madmaxms/theme-obsidian-2";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
