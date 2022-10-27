{ lib, stdenv, fetchFromGitHub
, bash-completion, perl, ncurses, zlib, sqlite, libffi
, mcpp, cmake, bison, flex, doxygen, graphviz
, makeWrapper
}:


let
  toolsPath = lib.makeBinPath [ mcpp ];
in
stdenv.mkDerivation rec {
  pname = "souffle";
  version = "2.3";

  src = fetchFromGitHub {
    owner  = "souffle-lang";
    repo   = "souffle";
    rev    = version;
    sha256 = "sha256-wdTBSmyA2I+gaSV577NNKA2oY2fdVTGmvV7h15NY1tU=";
  };

  nativeBuildInputs = [ bison cmake flex mcpp doxygen graphviz makeWrapper perl ];
  buildInputs = [ bash-completion ncurses zlib sqlite libffi ];
  # these propagated inputs are needed for the compiled Souffle mode to work,
  # since generated compiler code uses them. TODO: maybe write a g++ wrapper
  # that adds these so we can keep the propagated inputs clean?
  propagatedBuildInputs = [ ncurses zlib sqlite libffi ];

  cmakeFlags = [ "-DSOUFFLE_GIT=OFF" ];

  postInstall = ''
    wrapProgram "$out/bin/souffle" --prefix PATH : "${toolsPath}"
  '';

  outputs = [ "out" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A translator of declarative Datalog programs into the C++ language";
    homepage    = "https://souffle-lang.github.io/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice copumpkin wchresta ];
    license     = licenses.upl;
  };
}
