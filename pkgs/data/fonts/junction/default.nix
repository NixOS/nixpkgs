{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "junction";
  version = "2014-05-29";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "fb73260e86dd301b383cf6cc9ca8e726ef806535";
    hash = "sha256-Zqh23HPWGed+JkADYjYdsVNRxqJDvC9xhnqAqWZ3Eu8=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Junction is a a humanist sans-serif font";
    longDescription = ''
      Junction is a a humanist sans-serif, and the first open-source type
      project started by The League of Moveable Type. It has been updated
      (2014) to include additional weights (light/bold) and expanded
      international support.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/junction";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
