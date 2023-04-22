{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "cbqn-bytecode";
  version = "unstable-2023-01-27";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqnBytecode";
    rev = "b2f47806ea770451d06d04e20177baeaec92e6dd";
    hash = "sha256-dukpEB5qg6jF4AIHKK+atTvCKZTVtJ1M/nw7+SNp250=";
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
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk ];
    platforms = platforms.all;
  };
}
