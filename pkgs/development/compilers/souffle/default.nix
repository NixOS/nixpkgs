{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  bash-completion,
  perl,
  ncurses,
  zlib,
  sqlite,
  libffi,
  mcpp,
  cmake,
  bison,
  flex,
  doxygen,
  graphviz,
  makeWrapper,
}:

let
  toolsPath = lib.makeBinPath [ mcpp ];
in
stdenv.mkDerivation rec {
  pname = "souffle";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "souffle-lang";
    repo = "souffle";
    rev = version;
    sha256 = "sha256-U3/1iNOLFzuXiBsVDAc5AXnK4F982Uifp18jjFNUv2o=";
  };

  patches = [
    ./threads.patch
  ];

  hardeningDisable = lib.optionals stdenv.isDarwin [ "strictoverflow" ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    mcpp
    doxygen
    graphviz
    makeWrapper
    perl
  ];
  buildInputs = [
    bash-completion
    ncurses
    zlib
    sqlite
    libffi
  ];
  # these propagated inputs are needed for the compiled Souffle mode to work,
  # since generated compiler code uses them. TODO: maybe write a g++ wrapper
  # that adds these so we can keep the propagated inputs clean?
  propagatedBuildInputs = [
    ncurses
    zlib
    sqlite
    libffi
  ];

  cmakeFlags = [ "-DSOUFFLE_GIT=OFF" ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-but-set-variable";
  };

  postInstall = ''
    wrapProgram "$out/bin/souffle" --prefix PATH : "${toolsPath}"
  '';

  outputs = [ "out" ];

  meta = with lib; {
    description = "A translator of declarative Datalog programs into the C++ language";
    homepage = "https://souffle-lang.github.io/";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      copumpkin
      wchresta
    ];
    license = licenses.upl;
  };
}
