{
  lib,
  buildNpmPackage,
  fetchurl,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "tavily-mcp";
  version = "0.2.21";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-${finalAttrs.version}.tgz";
    hash = "sha256-kjD7sWzjCbLbNwRgbXxNHBOd9UG55ICMdZEI5naX1Pc=";
  };

  # The published npm tarball ships the prebuilt build/index.js but, like all
  # npm packages, omits the lockfile. Vendor it from the upstream source so
  # buildNpmPackage can resolve and fetch the runtime dependencies.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-G/cTvKMWzlc/u4peEjO977BwXNgzCIJXt+/0rArk3+w=";

  dontNpmBuild = true;
  npmPackFlags = [ "--ignore-scripts" ];

  # `nix-update --generate-lockfile` regenerates the vendored package-lock.json
  # (the npm tarball ships none) and refreshes npmDepsHash in one shot.
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "MCP server for advanced web search using Tavily";
    homepage = "https://github.com/tavily-ai/tavily-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
    ];
    mainProgram = "tavily-mcp";
    platforms = lib.platforms.all;
  };
})
