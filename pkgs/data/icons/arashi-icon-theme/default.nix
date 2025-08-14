{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "arashi-icon-theme";
  version = "unstable-2025-08-14";

  src = fetchFromGitHub {
    owner = "0hStormy";
    repo = "Arashi";
    rev = "main";
    sha256 = "sha256-MyhaSZD9HJL/FCXiMCMhpG7izhOcHZDf0zAGAyw8o7U=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r . $out/share/icons/Arashi

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Arashi icon theme";
    homepage = "https://github.com/0hStormy/Arashi";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ritascarlet ];
  };
}
