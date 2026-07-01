{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs-slim_22,
  nodejs,
  makeBinaryWrapper,
}:
let
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_22; };
  patchMissingPkgPrNewIntegrities = ''
    substituteInPlace pnpm-lock.yaml \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-core@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-GntAKmJ45uB5NUKeEw15qGpNmL9i81HmTv2OtqreAxT2uQb5Adurtx5VouR150tRhnkXoYUiVPzYGs++U+WLfg==, tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-core@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-dom@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-vbZgliMbBuVO1sYRhbczWWcQlwd8e+Wj6tGBh1PvRws6aJLu7nhMPb0LJU9wrW5EKFcjckGpwMtH3aOK/8padw==, tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-dom@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-sfc@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-e10xJOKE+jTmuoManPxtkRCUgu+IzpV67ZEcddzdE5+Va4gQuPTm4dzCYo0yEztyBH57AuhN8P3H1hC5SxyFuw==, tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-sfc@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-ssr@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-FxLmgdj7z0ljbHiT+PR4PtX+XNA+Pfb1Ror+9AP01fmHKGFb9ZVKqx0vBq4a2TtZXcgn5740IHiD0lovufBlFA==, tarball: https://pkg.pr.new/vuejs/core/@vue/compiler-ssr@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/reactivity@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-U4sPiVx/HN+SU/3nRxSvebg7diEsDK1x+xnbCoNy1IwVpNuogxyRz/L9bOGBIB9vlMmgmxsntDBltZVzoelwcQ==, tarball: https://pkg.pr.new/vuejs/core/@vue/reactivity@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/runtime-core@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-qKrCQUE2loNGO+zZ8S8TuSn2p0zaDTPZTom1RvaIVsriAYpd5AZdiy7b7PwT1OxdHK/OM3sZ1vvjysmQDUJLRg==, tarball: https://pkg.pr.new/vuejs/core/@vue/runtime-core@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/runtime-dom@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-k6YZlI+NYcDvj98OEmEpNteTX1q9l1dL2KCUCwCDmyAw2Re9Yz1J4JFEEnLCMz0+YSKoXg12lGj9lYVsuS6osw==, tarball: https://pkg.pr.new/vuejs/core/@vue/runtime-dom@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/server-renderer@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-yTJTHlRXU1qOXkQutMIF0w+s7zIfMACmiTrJQ4LZ50OAXKiWmt93nrSjXh6ePOP+KeRqvAOFBsZhlmnfxHHh/A==, tarball: https://pkg.pr.new/vuejs/core/@vue/server-renderer@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vuejs/core/@vue/shared@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-HCZjsf5q9+i2SxsraMsFVQvoSzW3/K6CC9Myg1CZJxP2MH+n6RYGqvJSEnjBCO3tX+JxLSrm06aYhn5FIZhhEw==, tarball: https://pkg.pr.new/vuejs/core/@vue/shared@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' \
      --replace-fail 'resolution: {tarball: https://pkg.pr.new/vue@e1bc0eb02e22bc0c236e1471c11d96a368764b72}' 'resolution: {integrity: sha512-lSY4wGk59hpvPBRJ1femqnUMekvvWGZsy4ggQBTJ8Z6fhDxO6U/w2l+M5vU93qsw2mcf9v+iuzLbEIc41y6B9w==, tarball: https://pkg.pr.new/vue@e1bc0eb02e22bc0c236e1471c11d96a368764b72}'
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vue-language-server";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "vuejs";
    repo = "language-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uiYhVVRiHyq+0S8czBY082vsqtCPqj29K9DjH0f+8u4=";
  };

  postPatch = patchMissingPkgPrNewIntegrities;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      postPatch
      src
      version
      ;
    inherit pnpm;
    fetcherVersion = 4;
    prePnpmInstall = ''
      pnpm config set --location project --json trustPolicyExclude '["volar-service-pug@0.0.71"]'
    '';
    hash = "sha256-6xu+z7rrI+YfmpcL5ycwjjeSAfDkkhSgeKBZO34p9Dw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build packages/language-server
    runHook postBuild
  '';

  preInstall = ''
    # the mv commands are workaround for https://github.com/pnpm/pnpm/issues/8307
    mv packages packages.dontpruneme
    CI=true pnpm prune --prod
    find packages.dontpruneme/**/node_modules -xtype l -delete
    mv packages.dontpruneme packages

    find -type f \( -name "*.ts" ! -name "*.d.ts" -o -name "*.map" \) -exec rm -rf {} +

    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules packages/language-server/node_modules -xtype l -delete

    # remove non-deterministic files
    rm node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/language-tools}
    cp -r {node_modules,packages,extensions} $out/lib/language-tools/

    makeWrapper ${lib.getExe nodejs} $out/bin/vue-language-server \
      --inherit-argv0 \
      --add-flags $out/lib/language-tools/packages/language-server/bin/vue-language-server.js

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official Vue.js language server";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ friedow ];
    mainProgram = "vue-language-server";
  };
})
