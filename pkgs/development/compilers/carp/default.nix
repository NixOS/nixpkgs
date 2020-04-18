{ stdenv, fetchFromGitHub, makeWrapper, clang, haskellPackages }:

haskellPackages.mkDerivation rec {

  pname = "carp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "carp-lang";
    repo = "Carp";
    rev = "v${version}";
    sha256 = "07yk3gy4l6h3k7sh8al7lgwk75a13zxwfp7siqpb5gnnqr1z3brc";
  };

  buildDepends = [ makeWrapper ];

  executableHaskellDepends = with haskellPackages; [
    HUnit blaze-markup blaze-html split cmdargs ansi-terminal cmark
    edit-distance
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
  license     = stdenv.lib.licenses.asl20;
  maintainers = with stdenv.lib.maintainers; [ jluttine ];

  # Windows not (yet) supported.
  platforms   = with stdenv.lib.platforms; unix ++ darwin;

}
