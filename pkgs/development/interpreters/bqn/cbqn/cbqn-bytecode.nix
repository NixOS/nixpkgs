{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "cbqn-bytecode";
  version = "unstable-2023-05-17";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqnBytecode";
    rev = "32db4dfbfc753835bf112f3d8ae2991d8aebbe3d";
    hash = "sha256-9uBPrEESn/rB9u0xXwKaQ7ABveQWPc8LRMPlnI/79kg=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D $src/gen/{compiles,explain,formatter,runtime0,runtime1,runtime1x,src} -t $out/dev

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/cbqnBytecode";
    description = "CBQN precompiled bytecode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      AndersonTorres
      sternenseemann
      synthetica
      shnarazk
      detegr
    ];
    platforms = platforms.all;
  };
}
