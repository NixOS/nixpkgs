{ lib, stdenv, fetchFromGitHub
, bash-completion, perl, ncurses, zlib, sqlite, libffi
, mcpp, cmake, bison, flex, doxygen, graphviz
, makeWrapper, writeShellScript
}:


let
  toolsPath = lib.makeBinPath [ mcpp ];
  # The build system of Soufflé 2.1 requires git on the $PATH, but will without
  # it as long as it exists with a non-zero code. This should be unnecessary in
  # the next release, see SOUFFLE_GIT in CMakeLists.txt.
  git = writeShellScript "git" "exit 1";
in
stdenv.mkDerivation rec {
  pname = "souffle";
  version = "2.1";

  src = fetchFromGitHub {
    owner  = "souffle-lang";
    repo   = "souffle";
    rev    = version;
    sha256 = "11x3v78kciz8j8p1j0fppzcyl2lbm6ib4svj6a9cwi836p9h3fma";
  };

  nativeBuildInputs = [ bison cmake flex git mcpp doxygen graphviz makeWrapper perl ];
  buildInputs = [ bash-completion ncurses zlib sqlite libffi ];

  # these propagated inputs are needed for the compiled Souffle mode to work,
  # since generated compiler code uses them. TODO: maybe write a g++ wrapper
  # that adds these so we can keep the propagated inputs clean?
  propagatedBuildInputs = [ ncurses zlib sqlite libffi ];

  patches = [ ./bash-completion-dir.patch ./lsb-release.patch ];

  # sic: The Soufflé CMakeLists.txt really does contain 'UNKOWN'. When bumping
  # this package, check that this is still true.
  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace 'UNKOWN' '${version}'
  '';

  postInstall = ''
    wrapProgram "$out/bin/souffle" --prefix PATH : "${toolsPath}"
  '';

  outputs = [ "out" ];

  meta = with lib; {
    description = "A translator of declarative Datalog programs into the C++ language";
    homepage    = "https://souffle-lang.github.io/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice copumpkin wchresta ];
    license     = licenses.upl;
  };
}
