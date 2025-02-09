{ lib
, stdenvNoCC
, fetchFromGitHub
, rename
}:

stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "unstable-2023-11-17";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "a90037f80d7db37279a7c1d863559e247ed81b05";
    hash = "sha256-96nEvc9eBuAncPUun3JBeg+KW2GqT3mQNgdOCVdhEM0=";
    sparseCheckout = [ "variablefont" ];
  };

  nativeBuildInputs = [ rename ];

  installPhase = ''
    runHook preInstall

    rename 's/\[FILL,GRAD,opsz,wght\]//g' variablefont/*
    install -Dm755 variablefont/*.ttf -t $out/share/fonts/TTF
    install -Dm755 variablefont/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    downloadPage = "https://github.com/google/material-design-icons";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.all;
  };
}
