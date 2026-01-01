{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
  makeWrapper,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zenn-cli";
  version = "0.2.10";
=======
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  nodejs,
  pnpm_9,
  testers,
}:
let
  go-turbo-version = "1.7.4";
  go-turbo-srcs = {
    x86_64-linux = fetchurl {
      url = "https://registry.npmjs.org/turbo-linux-64/-/turbo-linux-64-${go-turbo-version}.tgz";
      hash = "sha256-bwi+jthoDe+SEvCPPNNNv9AR8n5IA1fc4I8cnfC095Y=";
    };
    aarch64-linux = fetchurl {
      url = "https://registry.npmjs.org/turbo-linux-arm64/-/turbo-linux-arm64-${go-turbo-version}.tgz";
      hash = "sha256-j3mUd3x16tYR3QQweIB07IbCKYuKPeEkKkUHhrpHzyc=";
    };
  };
  go-turbo = stdenv.mkDerivation {
    pname = "go-turbo";
    version = go-turbo-version;
    src =
      go-turbo-srcs.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    nativeBuildInputs = [ autoPatchelfHook ];
    dontBuild = true;
    installPhase = ''
      install -Dm755 bin/go-turbo -t $out/bin
    '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zenn-cli";
  version = "0.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zenn-dev";
    repo = "zenn-editor";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-wItKDLAJHIyxUUaLIFM+sNYWtXKWC4P6GkCKn2Wh2JA=";
=======
    hash = "sha256-LFbC3GXYLCgBOYBdNJRdESGb37DuGBCEL8ak1Qf9DVA=";
    # turborepo requires .git directory
    leaveDotGit = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_10
    makeWrapper
  ];

  pnpmWorkspaces = [ "zenn-cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    hash = "sha256-WXsS5/J08n/dWV5MbyX4vK7j1mfiUoLdzwmzyqoX3FA=";
=======
    pnpm_9.configHook
    makeWrapper
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-AjdXclrNl1AHJ4LXq9I5Rk6KGyDaWXW187o2uLwRy/o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  preBuild = ''
    echo VITE_EMBED_SERVER_ORIGIN="https://embed.zenn.studio" > packages/zenn-cli/.env
<<<<<<< HEAD
=======
  ''
  # replace go-turbo since the existing one can't be executed
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp ${go-turbo}/bin/go-turbo node_modules/.pnpm/turbo-linux-*/node_modules/turbo-linux*/bin/go-turbo
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build --no-daemon

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    mkdir -p $out/{bin,lib/packages}
    rm -r node_modules packages/zenn-cli/node_modules
    pnpm install --filter=zenn-cli --prod --ignore-scripts
    cp -r node_modules $out/lib
    cp -r packages/zenn-cli $out/lib/packages/zenn-cli

    makeWrapper "${lib.getExe nodejs}" "$out/bin/zenn" \
      --add-flags "$out/lib/packages/zenn-cli/dist/server/zenn.js"
=======
    mkdir -p $out/{bin,lib/node_modules/zenn-cli}
    cp -r packages/zenn-cli/{dist,LICENSE,package.json,README.md} $out/lib/node_modules/zenn-cli

    makeWrapper "${lib.getExe nodejs}" "$out/bin/zenn" \
      --add-flags "$out/lib/node_modules/zenn-cli/dist/server/zenn.js"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Preview Zenn content locally";
    homepage = "https://github.com/zenn-dev/zenn-editor";
    changelog = "https://github.com/zenn-dev/zenn-editor/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "zenn";
    platforms = nodejs.meta.platforms;
  };
})
