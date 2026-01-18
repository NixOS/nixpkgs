{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-upgrade";
  version = "0.19.8";

  src = fetchFromGitHub {
    owner = "avh4";
    repo = "elm-upgrade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-frMh8PO9pDYTH03WlDUHuP3QPAz/oubxMYCcMlCU1MQ=";
  };

  npmDepsHash = "sha256-QP2dlsZb43/p3+P+uNPn3hd3zbKtlYRVl0ABXbv12V4=";

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    rm -rf $out/lib/node_modules/elm-upgrade/node_modules/.bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/avh4/elm-upgrade/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Upgrade your Elm 0.18 projects to Elm 0.19";
    homepage = "https://github.com/avh4/elm-upgrade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-upgrade";
  };
})
