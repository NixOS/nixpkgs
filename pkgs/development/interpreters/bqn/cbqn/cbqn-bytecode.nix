{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "cbqn-bytecode";
  version = "unstable-2023-04-19";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqnBytecode";
    rev = "78ed4102f914eb5fa490d76d4dcd4f8be6e53417";
    hash = "sha256-IOhxcfGmpARiTdFMSpc+Rh8VXtasZdfP6vKJzULNxAg=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D $src/gen/{compiles,explain,formatter,runtime0,runtime1,src} -t $out/dev

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
