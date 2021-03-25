{ lib, stdenv, fetchFromGitHub
, perl, ncurses, zlib, sqlite, libffi
, autoreconfHook, mcpp, bison, flex, doxygen, graphviz
, makeWrapper
}:


let
  toolsPath = lib.makeBinPath [ mcpp ];
in
stdenv.mkDerivation rec {
  pname = "souffle";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner  = "souffle-lang";
    repo   = "souffle";
    rev    = version;
    sha256 = "1fa6yssgndrln8qbbw2j7j199glxp63irfrz1c2y424rq82mm2r5";
  };

  nativeBuildInputs = [ autoreconfHook bison flex mcpp doxygen graphviz makeWrapper perl ];
  buildInputs = [ ncurses zlib sqlite libffi ];

  # these propagated inputs are needed for the compiled Souffle mode to work,
  # since generated compiler code uses them. TODO: maybe write a g++ wrapper
  # that adds these so we can keep the propagated inputs clean?
  propagatedBuildInputs = [ ncurses zlib sqlite libffi ];

  # see 565a8e73e80a1bedbb6cc037209c39d631fc393f and parent commits upstream for
  # Wno-error fixes
  patchPhase = ''
    substituteInPlace ./src/Makefile.am \
      --replace '-Werror' '-Werror -Wno-error=deprecated -Wno-error=other'

    substituteInPlace configure.ac \
      --replace "m4_esyscmd([git describe --tags --always | tr -d '\n'])" "${version}"
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
