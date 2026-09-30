{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "vernissage-push";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "VernissageApp";
    repo = "VernissagePush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5tatZsXjkVdfOO6FgJS6TmW73ml5/7MBp7qt4d3uJ78=";
  };
  npmDepsHash = "sha256-WaOPONnXaJSttMjwu+1akDvYghclza/p+XE/wK8o3wI=";

  strictDeps = true;

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    cp -R node_modules ./server.js $out/dist

    makeWrapper ${nodejs}/bin/node $out/bin/VernissagePush \
      --add-flags "$out/dist/server.js"

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vernissage push service";
    homepage = "https://github.com/VernissageApp/VernissagePush";
    changelog = "https://github.com/VernissageApp/VernissagePush/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "VernissagePush";
  };
})
