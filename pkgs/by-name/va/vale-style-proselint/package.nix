{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-proselint";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "proselint";
    rev = "v${version}";
    hash = "sha256-faeWr1bRhnKsycJY89WqnRv8qIowUmz3EQvDyjtl63w=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/proselint $out/share/vale/styles/proselint

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vale-compatible implementation of Python's proselint linter";
    homepage = "https://github.com/errata-ai/proselint";
    license = licenses.bsd3;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
