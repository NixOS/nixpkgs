{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-jade1";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-jade-1/releases/download/v${version}/jade-1-theme.tar.xz";
    sha256 = "11fzd44ysy76iwyiwkshpf0vf6m3i3hcxyyihl0lg68nb3cv0g9y";
  };

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Jade* $out/share/themes
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Based on Linux Mint theme with dark menus and more intensive green";
    homepage = "https://github.com/madmaxms/theme-jade-1";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
