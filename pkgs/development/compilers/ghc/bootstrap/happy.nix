# happy 1.19.5 compiled by MicroHs.  happy's own parsers are happy output, so
# they come from the chain's seed, and the check phase requires the happy built
# from them to regenerate them byte for byte.
{
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  ghc-bootstrap-src,
  mhs,
  mhsRuntime,
  cpphs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "happy-mhs";
  version = "1.19.5";

  src = fetchurl {
    url = "mirror://hackage/happy-${finalAttrs.version}/happy-${finalAttrs.version}.tar.gz";
    hash = "sha256-YvA6wR17S5kT8hL1qi7uEIfztG3AfXmdQeGFT/AoQ9o=";
  };

  nativeBuildInputs = [
    mhs
    cpphs
    makeBinaryWrapper
  ];

  hardeningDisable = [ "all" ];

  buildPhase = ''
    runHook preBuild

    mkdir datadir
    cpphs --noline templates/GenericTemplate.hs > datadir/HappyTemplate
    export HAPPY_DATADIR="$PWD/datadir"
    cp ${ghc-bootstrap-src}/happy/happy-seed/*.hs src/
    mhs -XCPP -i${ghc-bootstrap-src}/happy/noglr -i${ghc-bootstrap-src}/common/shims \
      -i${ghc-bootstrap-src}/happy/shim -isrc Main -ohappy.c
    cc -w -O1 -I${mhsRuntime} -I${mhsRuntime}/unix \
      ${mhsRuntime}/main.c ${mhsRuntime}/eval.c happy.c -lm -o happy

    mkdir regen
    for p in Parser AttrGrammarParser; do
      (cd src && ../happy "$p.ly" -o "../regen/$p.hs")
    done

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    for p in Parser AttrGrammarParser; do
      cmp "regen/$p.hs" "src/$p.hs"
    done

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D happy "$out/libexec/happy"
    install -Dm644 datadir/HappyTemplate "$out/share/happy/HappyTemplate"
    makeWrapper "$out/libexec/happy" "$out/bin/happy" \
      --set-default HAPPY_DATADIR "$out/share/happy"

    runHook postInstall
  '';

  meta.mainProgram = "happy";
})
