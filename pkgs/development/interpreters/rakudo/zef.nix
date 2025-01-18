{
  lib,
  stdenv,
  fetchFromGitHub,
  rakudo,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zef";
  version = "0.22.6";

  src = fetchFromGitHub {
    owner = "ugexe";
    repo = "zef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lq3jSoV1/zD7TMOtvfZZTVJ5cjsaod5Tzvb+GyiMJs4=";
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

  postFixup = ''
    wrapProgram $out/bin/zef --prefix RAKUDOLIB , "inst#$out"
  '';

  meta = with lib; {
    description = "Raku / Perl6 Module Management";
    homepage = "https://github.com/ugexe/zef";
    license = licenses.artistic2;
    mainProgram = "zef";
    maintainers = with maintainers; [ sgo ];
    platforms = platforms.unix;
  };
})
