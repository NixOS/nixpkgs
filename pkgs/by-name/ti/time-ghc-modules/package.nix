{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  sqlite,
  python3,
  coreutils,
  findutils,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "time-ghc-modules";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "codedownio";
    repo = "time-ghc-modules";
    rev = finalAttrs.version;
    sha256 = "sha256-/PhJAhP3KCWFyeSk8e5JV0cpBueH/eVDwQTMZSnnZCo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    cp ./time-ghc-modules $out/bin/time-ghc-modules
    wrapProgram $out/bin/time-ghc-modules --prefix PATH : ${
      lib.makeBinPath [
        sqlite
        python3
        coreutils
        findutils
        gnused
      ]
    } \
                                          --set PROCESS_SCRIPT $out/lib/process \
                                          --set HTML_FILE $out/lib/index.html

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    install -m 444 ./dist/index.html $out/lib
    install ./scripts/process $out/lib

    runHook postInstall
  '';

  meta = {
    description = "Analyze GHC .dump-timings files";
    mainProgram = "time-ghc-modules";
    homepage = "https://github.com/codedownio/time-ghc-modules";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thomasjm ];
    platforms = lib.platforms.all;
  };
})
