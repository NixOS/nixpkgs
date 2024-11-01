{ lib, stdenv, fetchFromGitHub
, bash-completion, perl, ncurses, zlib, sqlite, libffi
, mcpp, cmake, bison, flex, doxygen, graphviz
, makeWrapper, python3, callPackage
}:


let
  toolsPath = lib.makeBinPath [ mcpp python3 ];
in
stdenv.mkDerivation rec {
  pname = "souffle";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner  = "souffle-lang";
    repo   = "souffle";
    rev    = version;
    sha256 = "sha256-U3/1iNOLFzuXiBsVDAc5AXnK4F982Uifp18jjFNUv2o=";
  };

  patches = [
    ./threads.patch
    ./includes.patch
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isDarwin [ "strictoverflow" ];

  nativeBuildInputs = [ bison cmake flex mcpp doxygen graphviz makeWrapper perl ];
  buildInputs = [ bash-completion ncurses zlib sqlite libffi python3 ];
  # these propagated inputs are needed for the compiled Souffle mode to work,
  # since generated compiler code uses them. TODO: maybe write a g++ wrapper
  # that adds these so we can keep the propagated inputs clean?
  propagatedBuildInputs = [ ncurses zlib sqlite libffi ];

  cmakeFlags = [ "-DSOUFFLE_GIT=OFF" ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-but-set-variable";
  };

  postInstall = ''
    wrapProgram "$out/bin/souffle" --prefix PATH : "${toolsPath}"
  '';

  postFixup = ''
    substituteInPlace "$out/bin/souffle-compile.py" \
        --replace "-IPLACEHOLDER_FOR_INCLUDES_THAT_ARE_SET_BY_NIXPKGS" \
                  "-I${ncurses.dev}/include -I${zlib.dev}/include -I${sqlite.dev}/include -I${libffi.dev}/include -I$out/include"
  '';

  outputs = [ "out" ];

  passthru.tests = callPackage ./tests.nix { };

  meta = with lib; {
    description = "Translator of declarative Datalog programs into the C++ language";
    homepage    = "https://souffle-lang.github.io/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice copumpkin wchresta markusscherer ];
    license     = licenses.upl;
  };
}
