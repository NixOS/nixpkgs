{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "cbqn-bytecode";
<<<<<<< HEAD
  version = "unstable-2023-05-17";
=======
  version = "unstable-2023-04-19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqnBytecode";
<<<<<<< HEAD
    rev = "32db4dfbfc753835bf112f3d8ae2991d8aebbe3d";
    hash = "sha256-9uBPrEESn/rB9u0xXwKaQ7ABveQWPc8LRMPlnI/79kg=";
=======
    rev = "78ed4102f914eb5fa490d76d4dcd4f8be6e53417";
    hash = "sha256-IOhxcfGmpARiTdFMSpc+Rh8VXtasZdfP6vKJzULNxAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install -D $src/gen/{compiles,explain,formatter,runtime0,runtime1,runtime1x,src} -t $out/dev
=======
    install -D $src/gen/{compiles,explain,formatter,runtime0,runtime1,src} -t $out/dev
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/cbqnBytecode";
    description = "CBQN precompiled bytecode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk detegr ];
    platforms = platforms.all;
  };
}
