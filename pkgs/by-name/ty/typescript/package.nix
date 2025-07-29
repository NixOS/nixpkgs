{
  lib,
  buildNpmPackage,
  fetchurl,
  versionCheckHook,
  writeShellApplication,
  nodejs,
  gnutar,
  jq,
  moreutils,
  nix-update,
  prefetch-npm-deps,
}:

buildNpmPackage (finalAttrs: {
  pname = "typescript";
  version = "5.8.3";

  # Prefer npmjs over the GitHub repository for source code.
  # The TypeScript project typically publishes stable, versioned code to npmjs,
  # whereas GitHub tags may sometimes include development versions.
  # For example:
  #   - https://github.com/microsoft/TypeScript/pull/61218#issuecomment-2911264050
  #   - https://github.com/microsoft/TypeScript/pull/60150#issuecomment-2648791588, 5.8.3 includes this 5.9 breaking change
  src = fetchurl {
    url = "https://registry.npmjs.org/typescript/-/typescript-${finalAttrs.version}.tgz";
    hash = "sha256-cuddvrksLm65o0y1nXT6tcLubzKgMkqJQF9hZdWgg3Q=";
  };

  # The upstream GitHub repository's package-lock.json differs from the package.json in the npmjs tarball.
  # For example, package-lock.json for v5.8.3 defines TypeScript as version 5.9.0. Therefore, we should use our own package-lock.json file.
  # These files are typically large due to devDependencies. Removing the devDependencies section is better, especially considering issue #327064.
  #
  # We've removed devDependencies from package-lock.json via updateScript to minimize its size.
  # Now, we must also modify package.json to reflect this change.
  # As TypeScript will then have no dependencies, place an empty node_modules directory.
  postPatch = ''
    ${lib.getExe jq} 'del(.devDependencies)' package.json | ${moreutils}/bin/sponge package.json
    ln -s '${./package-lock.json}' package-lock.json
    mkdir -p node_modules
  '';

  npmDepsHash = "sha256-f/7Dxwoz0qv7T3Ez4jeRvmu7PxhzObwczjO7JcEcCr4=";
  forceEmptyCache = true;

  dontNpmBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/tsc";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "${finalAttrs.pname}-updater";
      runtimeInputs = [
        nodejs
        gnutar
        jq
        nix-update
        prefetch-npm-deps
      ];
      runtimeEnv = {
        PNAME = finalAttrs.pname;
        PKG_DIR = builtins.toString ./.;
        FORCE_EMPTY_CACHE = "true";
        OLD_NPM_DEPS_HASH = finalAttrs.npmDepsHash;
      };
      text = builtins.readFile ./update.bash;
    });
  };

  meta = {
    description = "Superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsc";
  };
})
