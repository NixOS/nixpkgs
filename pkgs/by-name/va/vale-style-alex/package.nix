{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-alex";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "alex";
    rev = "v${version}";
    hash = "sha256-xNF7se2FwKgNe5KYx/zvGWpIwBsBADYGH4JV1lUww+Q=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/alex $out/share/vale/styles/alex

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vale-compatible implementation of the guidelines enforced by the alex linter: catch insensitive, inconsiderate writing";
    homepage = "https://github.com/errata-ai/alex";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
