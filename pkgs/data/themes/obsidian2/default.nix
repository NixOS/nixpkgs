{ lib, stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.19";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-obsidian-2/releases/download/v${version}/obsidian-2-theme.tar.xz";
    sha256 = "sha256-GGnrix8utJ34pszuoxcMY5Yr0stwL17Y812FIiRZOUk=";
  };

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Obsidian-2* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "Gnome theme, based upon Adwaita-Maia dark skin";
    homepage = "https://github.com/madmaxms/theme-obsidian-2";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
