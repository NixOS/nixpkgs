{
  fetchPnpmDeps,
  lib,
  stdenv,

  lato,
  makeWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,

  # Login V2 is built and deployed independently of the API server, but from
  # the same source at the same version. The source pin and the generated
  # packages/zitadel-proto are taken from there.
  zitadel,
}:

let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zitadel-login";
  inherit (zitadel) src version;

  strictDeps = true;
  __structuredAttrs = true;

  # The login app needs different workspace packages out of the
  # repository-wide pnpm-lock.yaml than the console does, so this store is its
  # own rather than zitadel's.
  pnpmWorkspaces = [
    "@zitadel/client"
    "@zitadel/login"
    "@zitadel/proto"
  ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-WV1iz1VuvtjU2/PynNnbiPheQmLaRvuwTLcN3AioiqA=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm
    pnpmConfigHook
  ];

  env = {
    NODE_OPTIONS = "--max-old-space-size=8192";
    NEXT_TELEMETRY_DISABLED = "1";
  };

  # `next/font/google` downloads Lato from fonts.googleapis.com at build time,
  # which cannot work in the sandbox. Serve the same font from nixpkgs instead.
  patches = [ ./login-use-local-lato-font.patch ];

  postPatch = ''
    mkdir -p 'apps/login/src/app/(login)/fonts'
    install -m644 ${lato}/share/fonts/lato/Lato-{Regular,Bold,Black}.ttf \
      'apps/login/src/app/(login)/fonts/'
  '';

  preBuild = ''
    cp -r ${zitadel.protoPackageGenerated}/* packages/zitadel-proto/
    chmod -R u+w packages/zitadel-proto
  '';

  # Upstream builds this with the `build` target in apps/login/project.json,
  # which nx.json's targetDefaults make depend on the builds of the workspace
  # packages it uses.
  buildPhase = ''
    runHook preBuild

    pushd packages/zitadel-client
    pnpm run build
    popd

    pushd apps/login
    pnpm run build
    popd

    runHook postBuild
  '';

  # The Next.js standalone bundle expects to be run from its own root, the way
  # apps/login/Dockerfile does (`node apps/login/server.js`).
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/zitadel-login
    cp -r apps/login/.next/standalone/. $out/share/zitadel-login/

    makeWrapper ${lib.getExe' nodejs "node"} $out/bin/zitadel-login \
      --chdir $out/share/zitadel-login \
      --add-flags $out/share/zitadel-login/apps/login/server.js

    runHook postInstall
  '';

  meta = {
    description = "Login UI (v2) for the ZITADEL identity and access management platform";
    homepage = "https://zitadel.com/";
    downloadPage = "https://github.com/zitadel/zitadel/releases";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.byteflavour ];
    mainProgram = "zitadel-login";
  };
})
