{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "prociono";
  version = "2011-05-25";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "f9d9680de6d6f0c13939f23c9dd14cd7853cf844";
    hash = "sha256-gC5E0Z0O2cnthoBEu+UOQLsr3/a/3/JPIx3WCPsXXtk=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "A roman serif with blackletter elements";
    longDescription = ''
      "Prociono" (pro-tsee-O-no) is an Esperanto word meaning either the star
      Procyon or the animal species known as the raccoon. It is a roman serif
      with blackletter elements.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/prociono";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
