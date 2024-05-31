{ lib, fetchFromGitHub, fetchpatch, makeWrapper, clang, haskellPackages }:

haskellPackages.mkDerivation rec {
  pname = "carp";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "carp-lang";
    repo = "Carp";
    rev = "v${version}";
    sha256 = "sha256-B7SBzjegFzL2gGivIJE6BZcLD3f0Bsh8yndjScG2TZI=";
  };

  patches = [
    # Compat with GHC 9.2 / Stackage LTS 20, can be dropped at the next release
    # https://github.com/carp-lang/Carp/pull/1449
    (fetchpatch {
      name = "carp-lts-20.patch";
      url = "https://github.com/carp-lang/Carp/commit/25f50c92a57cc91b6cb4ec48df658439f936b641.patch";
      sha256 = "14yjv0hcvw1qyjmrhksrj6chac3n14d1f1gcaxldfa05llrbfqk0";
    })
  ];

  # -Werror breaks build with GHC >= 9.0
  # https://github.com/carp-lang/Carp/issues/1386
  postPatch = ''
    substituteInPlace CarpHask.cabal --replace "-Werror" ""
  '';

  buildTools = [ makeWrapper ];

  executableHaskellDepends = with haskellPackages; [
    HUnit blaze-markup blaze-html split ansi-terminal cmark
    edit-distance hashable open-browser optparse-applicative
  ];

  isExecutable = true;

  # The carp executable must know where to find its core libraries and other
  # files. Set the environment variable CARP_DIR so that it points to the root
  # of the Carp repo. See:
  # https://github.com/carp-lang/Carp/blob/master/docs/Install.md#setting-the-carp_dir
  #
  # Also, clang must be available run-time because carp is compiled to C which
  # is then compiled with clang.
  postInstall = ''
    wrapProgram $out/bin/carp                                  \
      --set CARP_DIR $src                                      \
      --prefix PATH : ${clang}/bin
    wrapProgram $out/bin/carp-header-parse                     \
      --set CARP_DIR $src                                      \
      --prefix PATH : ${clang}/bin
  '';

  description = "A statically typed lisp, without a GC, for real-time applications";
  homepage    = "https://github.com/carp-lang/Carp";
  license     = lib.licenses.asl20;
  maintainers = with lib.maintainers; [ jluttine ];
  # Not actively maintained at the moment
  broken      = true;

  # Windows not (yet) supported.
  platforms   = with lib.platforms; unix ++ darwin;
}
