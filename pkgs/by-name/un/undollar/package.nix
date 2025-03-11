{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
}:

stdenvNoCC.mkDerivation {
  pname = "undollar";
  version = "1.0.0-unstable-2018-09-14";

  src = fetchFromGitHub {
    owner = "xtyrrell";
    repo = "undollar";
    # Upstream has no tagged version
    rev = "27e5f0f87ddc4c9b58fe02a68e83a601078ebb43";
    hash = "sha256-2nudiUh8B5tSg3TeKh1FEJaf8MJ18/IkYikFD07c4Pw=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv undollar.js $out/bin/$
    substituteInPlace $out/bin/$ \
      --replace-fail "/usr/bin/env node" "${lib.getExe nodejs}"
    runHook postInstall
  '';

  meta = {
    description = "eats the dollar sign in the command you just pasted into your terminal";
    mainProgram = "$";
    homepage = "https://github.com/xtyrrell/undollar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    inherit (nodejs.meta) platforms;
  };
}
