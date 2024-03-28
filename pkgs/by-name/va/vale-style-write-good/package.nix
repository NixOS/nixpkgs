{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-write-good";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "write-good";
    rev = "v${version}";
    hash = "sha256-KQzY6MeHV/owPVmUAfzGUO0HmFPkD7wdQqOvBkipwP8=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/write-good $out/share/vale/styles/write-good

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vale-compatible implementation of the write-good linter";
    homepage = "https://github.com/errata-ai/write-good";
    changelog = "https://github.com/errata-ai/write-good/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
