{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-joblint";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "Joblint";
    rev = "v${version}";
    hash = "sha256-zRz5ThOg5RLTZj3dYPe0PDvOF5DjO31lduSpi2Us87U=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/Joblint $out/share/vale/styles/Joblint

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vale-compatible implementation of the Joblint linter";
    homepage = "https://github.com/errata-ai/Joblint";
    changelog = "https://github.com/errata-ai/Joblint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
