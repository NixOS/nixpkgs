{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lexend";
  version = "0.pre+date=2022-09-22";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = pname;
    rev = "cd26b9c2538d758138c20c3d2f10362ed613854b";
    sha256 = "ZKogntyJ/44GBZmFwbtw5Ujw5Gnvv0tVB59ciKqR4c8=";
  };

  installPhase = ''
    runHook preInstall

    cd fonts
    for f in *; do
      install -D -t $out/share/fonts/truetype/lexend/$f $f/ttf/*
      install -D -t $out/share/fonts/variable/lexend/$f $f/variable/*
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
