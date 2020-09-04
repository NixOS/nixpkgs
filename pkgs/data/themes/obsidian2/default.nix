{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-obsidian-2";
    rev = "v${version}";
    sha256 = "0i5lrj45zswd3rmclvywpk7x30bvib5zldhmfl38gbj477ag8ng8";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Obsidian-2 $out/share/themes
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Gnome theme, based upon Adwaita-Maia dark skin";
    homepage = "https://github.com/madmaxms/theme-obsidian-2";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
