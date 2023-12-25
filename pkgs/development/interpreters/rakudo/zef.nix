{ lib
, stdenv
, fetchFromGitHub
, rakudo
, makeBinaryWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zef";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "ugexe";
    repo = "zef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7mqKcioMal4OR/xlzQ/EgGICau7Ijc13j4pSfu4/74E=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    rakudo
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    # TODO: Find better solution. zef stores cache stuff in $HOME with the
    # default config.
    env HOME=$TMPDIR ${rakudo}/bin/raku -I. ./bin/zef --/depends --/test-depends --/build-depends --install-to=$out install .

    runHook postInstall
  '';

  postFixup =''
    wrapProgram $out/bin/zef --prefix RAKUDOLIB , "inst#$out"
  '';

  meta = {
    description = "Raku / Perl6 Module Management";
    homepage    = "https://github.com/ugexe/zef";
    license     = lib.licenses.artistic2;
    mainProgram = "zef";
    maintainers = with lib.maintainers; [ sgo ];
    platforms   = lib.platforms.unix;
  };
})
