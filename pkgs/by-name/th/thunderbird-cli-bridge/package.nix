{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "thunderbird-cli-bridge";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vitalio-sh";
    repo = "thunderbird-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WSbczKPxTyaSqYeI8WYKpo983sfJWa7QCYbElMetUqY=";
  };

  forceEmptyCache = true;
  dontNpmBuild = true;

  npmWorkspace = "bridge";
  npmDepsHash = "sha256-1+VkzCrLZvL7XUxoK/AazwSR3yLqgZ4CGJwDAJ2e+5U=";

  # TODO: revisit this when https://github.com/NixOS/nixpkgs/pull/333759 has landed
  postInstall = ''
    rm -rf $out/lib/node_modules/thunderbird-cli/node_modules/thunderbird-cli-bridge
    rm -rf $out/lib/node_modules/thunderbird-cli/node_modules/.bin/tb
    rm -rf $out/lib/node_modules/thunderbird-cli/node_modules/.bin/tb-bridge
    rm -rf $out/lib/node_modules/thunderbird-cli/node_modules/.bin/tb-mcp
    rm -rf $out/lib/node_modules/thunderbird-cli/node_modules/thunderbird-cli
    rm -rf $out/lib/node_modules/thunderbird-cli/node_modules/thunderbird-cli-mcp
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "HTTP/WebSocket bridge daemon between thunderbird-cli (or any HTTP client) and the Thunderbird-cli WebExtension. Stateless proxy, localhost-only.";
    homepage = "https://github.com/vitalio-sh/thunderbird-cli";
    changelog = "https://github.com/vitalio-sh/thunderbird-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "tb-bridge";
    platforms = lib.platforms.all;
  };
})
