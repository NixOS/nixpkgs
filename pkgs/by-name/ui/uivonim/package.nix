{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "uivonim";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "smolck";
    repo = "uivonim";
    rev = "v${version}";
    hash = "sha256-TcsKjRwiCTRQLxolRuJ7nRTGxFC0V2Q8LQC5p9iXaaY=";
  };

  npmDepsHash = "sha256-jWLvsN6BCxTWn/Lc0fSz0VJIUiFNN8ptSYMeWlWsHXc=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "build:prod";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/uivonim \
      --add-flags $out/lib/node_modules/uivonim/build/main/main.js
  '';

  meta = with lib; {
    homepage = "https://github.com/smolck/uivonim";
    description = "Cross-platform GUI for neovim based on electron";
    maintainers = [ ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
    mainProgram = "uivonim";
  };
}
