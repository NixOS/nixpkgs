{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "lexend";
  version = "0.pre+date=2022-01-27";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = pname;
    rev = "57e6c14e2a9b457e8376044a31525c2100297e9c";
    sha256 = "sha256-+tPggQIO50a8kOSnOVN/MR9ZwX5xZqYVNZO79eog9QA=";
  };

  installPhase = ''
    runHook preInstall

    cd fonts
    for f in *; do
      mkdir -p $out/share/fonts/truetype/lexend/$f
      install $f/ttf/* $out/share/fonts/truetype/lexend/$f/
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.lexend.com";
    description = "A variable font family designed to aid in reading proficiency";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ fufexan ];
  };
}
