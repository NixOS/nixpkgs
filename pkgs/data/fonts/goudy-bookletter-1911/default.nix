{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "goudy-bookletter-1911";
  version = "2011-05-11";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "85ff5b834b4f63feb36fd2053949c19660580e48";
    hash = "sha256-11axs1+SRQj+1lYTq2LYf1I65WrrvB/UnAgZkHPP1N8=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Public domain font based on Frederic Goudy’s Kennerley Oldstyle";
    homepage = "https://www.theleagueofmoveabletype.com/goudy-bookletter-1911";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
