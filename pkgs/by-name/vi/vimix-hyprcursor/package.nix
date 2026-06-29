{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  hyprcursor,
}:
stdenvNoCC.mkDerivation {
  pname = "vimix-hyprcursor";
  version = "0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "BlackFuffey";
    repo = "vimix-hyprcursor";
    rev = "c2314d02e9dfe592c4c1281bbf2c8d5873fb03e9";
    hash = "sha256-j7towY9u6AIoKqsq/X6BIssrfpY+lhAibBvIUcjc6dk=";
  };

  buildInputs = [ hyprcursor ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/icons

    hyprcursor-util --create $src/src/Vimix-normal --output $out/share/icons
    hyprcursor-util --create $src/src/Vimix-white --output $out/share/icons

    mv $out/share/icons/{theme_,}Vimix\ Cursors
    mv $out/share/icons/{theme_,}Vimix\ Cursor\ White

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Vimix theme for Hyprcursor";
    homepage = "https://github.com/BlackFuffey/vimix-hyprcursor";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ redxtech ];
  };
}
