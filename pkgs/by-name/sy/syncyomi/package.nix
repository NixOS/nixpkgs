{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  iana-etc,
  libredirect,
  buildGoModule,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  esbuild,
  nix-update-script,
}:
let
  lockedEsbuild = esbuild.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "0.21.5";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        tag = "v${finalAttrs.version}";
        hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    }
  );
in
buildGoModule (finalAttrs: {
  pname = "syncyomi";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "SyncYomi";
    repo = "SyncYomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ot8c7+a/YLhjt9HkcI8QZ2ICgtBj3VGJhxtnhWC0f+0=";
  };

  vendorHash = "sha256-7AySGQBQHaTp2M1uj5581ZqcpzgexI1KvanWMOc6rx0=";

  web = stdenvNoCC.mkDerivation (webFinalAttrs: {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;
    sourceRoot = "${webFinalAttrs.src.name}/web";

    pnpmDeps = fetchPnpmDeps {
      inherit (webFinalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_9;
      fetcherVersion = 3;
      hash = "sha256-paCYfh7tjDuPm8JCpzhCNjL1ZsyQTNxofW8UNIKjqmE=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
    ];

    env.ESBUILD_BINARY_PATH = lib.getExe lockedEsbuild;

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  });

  preConfigure = ''
    cp -r $web/* web/dist
  '';

  nativeCheckInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [ libredirect.hook ];

  preCheck = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (!stdenvNoCC.hostPlatform.isDarwin) ''
    mv $out/bin/SyncYomi $out/bin/syncyomi
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source project to synchronize Tachiyomi manga reading progress and library across multiple devices";
    homepage = "https://github.com/SyncYomi/SyncYomi";
    changelog = "https://github.com/SyncYomi/SyncYomi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      eriedaberrie
      miniharinn
    ];
    mainProgram = "syncyomi";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
