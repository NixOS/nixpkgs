{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-live";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "wking-io";
    repo = "elm-live";
    tag = finalAttrs.version;
    hash = "sha256-pLBSFfe+46uMDC96Pz7Tp14fgZo4elZnhvIdeJGkZ1s=";
  };

  npmDepsHash = "sha256-OFOlmlE9lyrJ0uyzsqomrHNxKb4jNKtKvxhqK0Dh07k=";

  dontNpmBuild = true;

  postInstall = ''
    rm -rf $out/lib/node_modules/elm-live/node_modules/.bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/wking-io/elm-live/releases/tag/${finalAttrs.version}";
    description = "Flexible dev server for Elm with live-reload";
    homepage = "https://www.elm-live.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-live";
  };
})
