{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "nonicons";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "yamatsum";
    repo = "nonicons";
    rev = "df0c8daa5d22dfef518264a243eb1fc99a10c10d";
    sha256 = "sha256:uxG7P4rd9bhm7YqsUWCy2blv/ylXzJOnzbsudhdkS08=";
  };

  # only extract the variable font because everything else is a duplicate
  installPhase = ''
    runHook preInstall

    install -Dm644 dist/nonicons.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/yamatsum/nonicons";
    description = "A set of SVG icons representing programming languages, designing & development tools";
    license = licenses.mit;
    maintainers = with maintainers; [ maximiliangaedig ];
    platforms = platforms.all;
  };
}
