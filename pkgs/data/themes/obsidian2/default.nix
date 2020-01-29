{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-obsidian2";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-obsidian-2";
    rev = "v${version}";
    sha256 = "123f6hpz0h5xfmas44xa1ci68w8f3lcjj54jpnrqhsww66c9vs0i";
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
    homepage = https://github.com/madmaxms/theme-obsidian-2;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
