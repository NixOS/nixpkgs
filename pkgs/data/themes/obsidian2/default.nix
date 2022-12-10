{ lib, stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.21";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-obsidian-2/releases/download/v${version}/obsidian-2-theme.tar.xz";
    sha256 = "sha256-ptiJeb4ebfnH6HpTN1NsPAYbkLlPcZtn2aBKO0zW2Tw=";
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
