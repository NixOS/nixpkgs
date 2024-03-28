{ lib
, fetchurl
, nix-update-script
, stdenvNoCC
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yacd";
  version = "0.3.8";

  src = fetchurl {
    url = "https://github.com/haishanh/yacd/releases/download/v${finalAttrs.version}/yacd.tar.xz";
    hash = "sha256-1dfs3pGnCKeThhFnU+MqWfMsjLjuyA3tVsOrlOURulA";
  };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./public/* $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet Another Clash Dashboard";
    homepage = "https://github.com/haishanh/yacd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ Guanran928 ];
  };
})
