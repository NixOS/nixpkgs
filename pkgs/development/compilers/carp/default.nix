{ stdenv, fetchFromGitHub, makeWrapper, clang, haskellPackages }:

haskellPackages.mkDerivation {

  pname = "carp";
  version = "unstable-2018-09-15";

  src = fetchFromGitHub {
    owner = "carp-lang";
    repo = "Carp";
    rev = "cf9286c35cab1c170aa819f7b30b5871b9e812e6";
    sha256 = "1k6kdxbbaclhi40b9p3fgbkc1x6pc4v0029xjm6gny6pcdci2cli";
  };

  buildDepends = [ makeWrapper ];

  executableHaskellDepends = with haskellPackages; [
    HUnit blaze-markup blaze-html split cmdargs
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
  homepage    = https://github.com/carp-lang/Carp;
  license     = stdenv.lib.licenses.asl20;
  maintainers = with stdenv.lib.maintainers; [ jluttine ];

  # Windows not (yet) supported.
  platforms   = with stdenv.lib.platforms; unix ++ darwin;

}
