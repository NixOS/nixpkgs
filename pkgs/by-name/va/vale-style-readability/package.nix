{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-readability";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "readability";
    rev = "v${version}";
    hash = "sha256-5Y9v8QsZjC2w3/pGIcL5nBdhpogyJznO5IFa0s8VOOI=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/Readability $out/share/vale/styles/Readability

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Vale-compatible implementations of many popular \"readability\" metrics";
    homepage = "https://github.com/errata-ai/readability";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
