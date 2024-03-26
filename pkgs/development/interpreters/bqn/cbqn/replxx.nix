{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "replxx";
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "replxx";
    rev = "13f7b60f4f79c2f14f352a76d94860bad0fc7ce9";
    hash = "sha256-xPuQ5YBDSqhZCwssbaN/FcTZlc3ampYl7nfl2bbsgBA=";
  };

  dontConfigure = true;
  # The CBQN derivation will build replxx, here we just provide the source files.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dev
    cp -r $src $out/dev

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/replxx";
    description = "A replxx fork for CBQN";
    license = licenses.free;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk detegr ];
    platforms = platforms.all;
  };
}
