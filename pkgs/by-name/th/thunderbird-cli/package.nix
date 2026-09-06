{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "thunderbird-cli";
  version = "1.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vitalio-sh";
    repo = "thunderbird-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jtIXOHjijFkwdh5FWrqdSfEwbEmWQud8Qr2jsTEwJts=";
  };

  forceEmptyCache = true;
  dontNpmBuild = true;

  npmWorkspace = "cli";
  npmDepsHash = "sha256-ixzfebmKITD1lnPNQq765S1f+i7xBTTWWdZoJOqY7qg=";

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
    description = "Low-level CLI to manage Mozilla Thunderbird email from the shell";
    homepage = "https://github.com/vitalio-sh/thunderbird-cli";
    changelog = "https://github.com/vitalio-sh/thunderbird-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "tb";
    platforms = lib.platforms.all;
  };
})
