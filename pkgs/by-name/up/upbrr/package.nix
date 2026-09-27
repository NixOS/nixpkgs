{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  fetchpatch,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  typescript,
  ffmpeg-headless,
  makeWrapper,
  gitMinimal,
  writableTmpDirAsHomeHook,
}:
buildGo127Module (finalAttrs: {
  pname = "upbrr";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "upbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kdc/MEIrNfbyVYsdXvjwvtrMO0jH8vKPTC2thVZXB3A=";
  };

  patches = [
    # One of the tests that is executed checks path redaction from the logs,
    # and expects TMPDIR to be in /tmp. Since nix sets it inside the nix build,
    # we need to fix it to be able to execute those tests during the build.
    # This patch corresponds to the upstream PR
    # https://github.com/autobrr/upbrr/pull/431 which fixs this.
    (fetchpatch {
      url = "https://github.com/autobrr/upbrr/commit/2b1faf8e1dfd006ffb97f3d694e2a6af71afad77.patch";
      hash = "sha256-/l2gb2zSLPJiFP7ffdGehc63EJrNLCGQvGCBYVPbRTI=";
    })
  ];

  __structuredAttrs = true;

  upbrr-webui = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-webui";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpmBuildHook
      pnpm_11
      typescript
    ];

    sourceRoot = "${finalAttrs.src.name}/webui";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs')
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-8AnituGTEld/x3R+WtLSMeERPZgo5JtiQdB6CBaYlpY=";
    };

    pnpmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  });

  vendorHash = "sha256-x689FL48PmxSLR2OpzEAVteEqUFuuKaZHlJmLRrMeuY=";

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    mkdir -p "internal/webserver/assets"
    cp -R ${finalAttrs.upbrr-webui}/. "internal/webserver/assets"
  '';

  postInstall = ''
    wrapProgram $out/bin/upbrr \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.buildIdentifier="
  ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # This test conflicts with the writableTmpDirAsHomeHook, since now the
    # directory it picks is going to be inside a temp path and will therefore
    # be censored.
    "-skip=TestSanitizeMessageDoesntCensorPathsSimilarToTmp"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "upbrr-webui"
      ];
    };
  };

  meta = {
    description = "Guided private-tracker upload preparation: metadata, dupe checks, screenshots, descriptions, submission, and torrent-client integration";
    license = lib.licenses.gpl2Plus;
    homepage = "https://upbrr.com";
    changelog = "https://github.com/autobrr/upbrr/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      pta2002
    ];
    mainProgram = "upbrr";
    platforms = lib.platforms.unix;
  };
})
