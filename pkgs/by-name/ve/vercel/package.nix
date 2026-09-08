{
  lib,
  buildNpmPackage,
  fetchzip,
  jq,
  nodejs,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "vercel";
  version = "59.11.7";

  src = fetchzip {
    url = "https://registry.npmjs.org/vercel/-/vercel-${finalAttrs.version}.tgz";
    hash = "sha256-iTxjxoWxyWXOcNmDMvDsHd80jlWZ9ryfQdgkHChHrJA=";
    # nix-update generates the lockfile from src, before postPatch runs.
    # Development dependencies include private packages; use the Node.js CLI.
    postFetch = ''
      ${lib.getExe jq} '
        del(.devDependencies)
        | .optionalDependencies |= with_entries(
            select(.key | startswith("@vercel/vc-native-") | not)
          )
      ' "$out/package.json" > "$out/package.json.tmp"
      mv "$out/package.json.tmp" "$out/package.json"
      echo 'ignore-scripts=true' > "$out/.npmrc"
    '';
  };

  npmDepsHash = "sha256-b+QdjbQaaWWQfXuaA0maNM33fPhSET+Cuh+KKSWE6Bc=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    # The npm release has a compiled-in Sentry DSN.
    substituteInPlace dist/index.js --replace-fail 'dsn: SENTRY_DSN,' 'dsn: "",'
  '';

  dontNpmBuild = true;
  npmFlags = [ "--ignore-scripts" ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ nodejs ])
    "--set"
    "NO_UPDATE_NOTIFIER"
    "1"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  postInstallCheck = ''
    "$out/bin/vercel" --help > /dev/null
    "$out/bin/vc" --version
    node ${./install-check.cjs} ${stdenv.shell}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Command-line interface for Vercel";
    homepage = "https://vercel.com/docs/cli";
    changelog = "https://vercel.com/docs/cli/release-notes";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
      binaryBytecode
    ];
    mainProgram = "vercel";
    maintainers = with lib.maintainers; [ lmdevv ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
