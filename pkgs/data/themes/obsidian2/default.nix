{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-obsidian-2";
    rev = "v${version}";
    sha256 = "1chbz1cbkbfzk8835x1dywk38d7wjh90myajgk5f7v2zgnvbya23";
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
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
