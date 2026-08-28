{
  lib,
  buildGoModule,
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
  ffmpeg,
  makeWrapper,
  git,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "upbrr";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "upbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EmMXkFPV339U1qIwxmtRbhqLbA23lc8WV3RqsEF6Puk=";
  };

  patches = [
    # One of the tests that is executed checks path redaction from the logs,
    # and expects TMPDIR to be in /tmp. Since nix sets it inside the nix build,
    # we need to fix it to be able to execute those tests during the build.
    # This patch corresponds to the upstream PR
    # https://github.com/autobrr/upbrr/pull/431 which fixs this.
    (fetchpatch {
      url = "https://github.com/autobrr/upbrr/commit/9d1bc051a52e1c040ee53b7b76db1662cba2031f.patch";
      hash = "sha256-YwfXepx4iwOnpHRzYF9b2gdFkSqdapQy5Rc3awOMhjg=";
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
      hash = "sha256-eMpoFe+TfD1MVQM4JrXrfgc4MNjkeDT3GAVXJ8sbp/A=";
    };

    pnpmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  });

  vendorHash = "sha256-fbqCCmSPfjtwyUituQ/wXvsm6Xs6QyJjvKOlpuPkr3w=";

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    mkdir -p "internal/webserver/assets"
    cp -R ${finalAttrs.upbrr-webui}/. "internal/webserver/assets"
  '';

  postInstall = ''
    wrapProgram $out/bin/upbrr \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.buildIdentifier="
  ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
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
    description = "Guided private-tracker upload preparation: metadata, dupe checks, screenshots, descriptions, submission, and torrent-client integration.";
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
