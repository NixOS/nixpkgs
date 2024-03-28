{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-microsoft";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "Microsoft";
    rev = "v${version}";
    hash = "sha256-22rGNLZOsWYQ+H3CcM2b1zOXV3kNPcgYqDpaCg1iv9o=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/Microsoft $out/share/vale/styles/Microsoft

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vale-compatible implementation of the Microsoft Writing Style Guide";
    homepage = "https://github.com/errata-ai/Microsoft";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
