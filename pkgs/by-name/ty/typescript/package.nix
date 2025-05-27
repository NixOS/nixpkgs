{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  replaceVars,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "typescript";
  version = "5.8.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/XxjZO/pJLLAvsP7x4TOC+XDbOOR+HHmdpn+8qP77L8=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch

    # Should be removed in next 5.9.X TypeScript update: https://github.com/microsoft/TypeScript/pull/61218#issuecomment-2911264050
    (replaceVars ./revert-bump-to-v5.9.patch {
      inherit (finalAttrs) version;
    })
  ];

  postPatch = ''
    # The test run in the build script is redundant with checkPhase
    substituteInPlace package.json \
     --replace-fail ' && npm run build:tests' ""

    # Should be removed in next 5.9.X TypeScript update
    substituteInPlace src/compiler/corePublic.ts \
      --replace-fail 'versionMajorMinor = "5.9"' 'versionMajorMinor = "5.8"'
    substituteInPlace tests/baselines/reference/api/typescript.d.ts \
      --replace-fail 'versionMajorMinor = "5.9"' 'versionMajorMinor = "5.8"'

    # Imported from https://github.com/microsoft/TypeScript/blob/b504a1eed45e35b5f54694a1e0a09f35d0a5663c/.github/workflows/set-version.yaml#L75
    sed -i -e 's/const version\(: string\)\{0,1\} = .*;/const version = "${finalAttrs.version}" as string;/g' src/compiler/corePublic.ts
  '';

  npmDepsHash = "sha256-BHJGezzZensC/WFsUumJSk6TYAqbS50Inuvw2nV5vUk=";

  postBuild = ''
    npx hereby lkg
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/tsc";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([\\d.]+)$"
      ];
    };
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
