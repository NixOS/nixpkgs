{ lib, stdenv, fetchFromGitHub
, bash-completion, perl, ncurses, zlib, sqlite, libffi
, mcpp, cmake, bison, flex, lsb-release, git, doxygen, graphviz
, makeWrapper
}:


let
  toolsPath = lib.makeBinPath [ mcpp ];
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

  nativeBuildInputs = [ bison cmake flex lsb-release git mcpp doxygen graphviz makeWrapper perl ];
  buildInputs = [ bash-completion ncurses zlib sqlite libffi ];

  # these propagated inputs are needed for the compiled Souffle mode to work,
  # since generated compiler code uses them. TODO: maybe write a g++ wrapper
  # that adds these so we can keep the propagated inputs clean?
  propagatedBuildInputs = [ ncurses zlib sqlite libffi ];

  patches = [ ./bash-completion-dir.patch ];

  # sic: The Soufflé CMakeLists.txt really does contain 'UNKOWN'. When bumping
  # this package, check that this is still true.
  prePatch = ''
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
