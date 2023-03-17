{ lib
, stdenv
, fetchurl
, gtk-engine-murrine
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.22";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-obsidian-2/releases/download/v${version}/obsidian-2-theme.tar.xz";
    sha256 = "sha256-WvSlzCock0UMdvajHRBNHSugVMStR1FDt9vjzX5Kp8A=";
  };

  sourceRoot = ".";

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Obsidian-2* $out/share/themes
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
