{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "vale-style-google";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "Google";
    rev = "v${version}";
    hash = "sha256-TQS/hgS6tEWPSuZpEbX65MdYSE/+HJVcnzIuQbhIG2M=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/vale/styles
    cp -R $src/Google $out/share/vale/styles/Google

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vale-compatible implementation of the Google Developer Documentation Style Guide";
    homepage = "https://github.com/errata-ai/Google";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.all;
  };
}
