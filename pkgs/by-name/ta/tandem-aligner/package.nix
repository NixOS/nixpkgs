{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "TandemAligner";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "seryrzu";
    repo = "tandem_aligner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iMDj1HZ8LzmZckuAM3lbG3eSJSd/5JGVA6SBs7+AgX8=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/seryrzu/tandem_aligner/pull/4
      url = "https://github.com/seryrzu/tandem_aligner/commit/8b516c94f90aaa9cb84278aa811285d4204b03a9.patch";
      hash = "sha256-kD46SykXklG/avK0+sc61YKFw9Bes8ZgFAjVXmcpN8k=";
      stripLen = 1;
    })
  ];

  sourceRoot = "${finalAttrs.src.name}/tandem_aligner";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/projects/tandem_aligner/tandem_aligner $out/bin
    runHook postInstall
  '';

  doCheck = true;

  # adapted from target test_launch in Makefile
  checkPhase = ''
    runHook preCheck
    mkdir -p $TMPDIR/test_launch
    src/projects/tandem_aligner/tandem_aligner \
      --first $src/tandem_aligner/test_dataset/first.fasta \
      --second $src/tandem_aligner/test_dataset/second.fasta \
      -o $TMPDIR/test_launch \
      --debug
    grep -q "Thank you for using TandemAligner!" $TMPDIR/test_launch/tandem_aligner.log
    diff $TMPDIR/test_launch/cigar.txt $src/tandem_aligner/test_dataset/true_cigar.txt
    runHook postCheck
  '';

  meta = {
    description = "Parameter-free algorithm for sequence alignment";
    homepage = "https://github.com/seryrzu/tandem_aligner";
    changelog = "https://github.com/seryrzu/tandem_aligner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = lib.platforms.linux;
    mainProgram = "tandem_aligner";
  };
})
