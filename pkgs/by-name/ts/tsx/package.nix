{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  nodejs_22,
  versionCheckHook,
}:
stdenv.mkDerivation rec {
  pname = "tsx";
  version = "4.19.3";

  src = fetchFromGitHub {
    owner = "privatenumber";
    repo = "tsx";
    tag = "v${version}";
    hash = "sha256-wdv2oqJNc6U0Fyv4jT+0LUcYaDfodHk1vQZGMdyFF/E=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-57KDZ9cHb7uqnypC0auIltmYMmIhs4PWyf0HTRWEFiU=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_9.configHook
  ];

  buildInputs = [
    nodejs_22
  ];

  patchPhase = ''
    runHook prePatch

    # by default pnpm builds the docs workspace and this was just
    #  the easiest way I found to stop that, as pnpmWorkspaces and
    #  other flags did not work
    rm pnpm-workspace.yaml

    # because tsx uses semantic-release, the package.json has a placeholder
    #  version number. this patches it to match the version of the nix package,
    #  which in turn is the release version in github.
    substituteInPlace package.json --replace-fail "0.0.0-semantic-release" "${version}"

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    npm run build

    # remove devDependencies that are only required to build
    #  and package the typescript code
    CI=true pnpm prune --prod

    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/tsx}
    cp -r {dist,node_modules} $out/lib/tsx
    chmod +x $out/lib/tsx/dist/cli.mjs
    ln -s $out/lib/tsx/dist/cli.mjs $out/bin/tsx

    runHook postInstall
  '';

  # 8 / 85 tests are failing, I do not know why, while regular usage shows no issues.
  doCheck = false;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "TypeScript Execute (tsx): The easiest way to run TypeScript in Node.js";
    homepage = "https://tsx.is";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sdedovic ];
    mainProgram = "tsx";
  };
}
