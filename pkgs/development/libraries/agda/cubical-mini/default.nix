{
  lib,
  mkDerivation,
  fetchFromGitHub,
  ghc,
  cabal-install,
}:

mkDerivation rec {
  pname = "cubical-mini";
  version = "nightly-20241214";

  src = fetchFromGitHub {
    repo = pname;
    owner = "cmcmA20";
    rev = "ab18320018ddc0055db60d4bb5560d31909c5b78";
    hash = "sha256-32qXY9KbProdPwqHxSkwO74Oqx65rTzoXtH2SpRB3OM=";
  };

  nativeBuildInputs = [
    ghc
    cabal-install
  ];

  # Makefile uses `cabal run` which tries to write its default config to $HOME and download package
  # lists. We need to create an empty config file to make cabal work offline.
  buildPhase = ''
    runHook preBuild
    export HOME=$TMP
    mkdir $HOME/.cabal
    touch $HOME/.cabal/config
    make
    runHook postBuild
  '';

  meta = {
    homepage = "https://github.com/cmcmA20/cubical-mini";
    description = "A nonstandard library for Cubical Agda";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thelissimus ];
  };
}
