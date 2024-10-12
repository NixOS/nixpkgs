{ lib
, stdenvNoCC
, fetchFromGitHub
, buildGoModule
, nodejs
, pnpm_9
, esbuild
}:

buildGoModule rec {
  pname = "syncyomi";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "SyncYomi";
    repo = "SyncYomi";
    rev = "refs/tags/v${version}";
    hash = "sha256-90MA62Zm9ouaf+CnYsbOm/njrUui21vW/VrwKYfsCZs=";
  };

  vendorHash = "sha256-/rpT6SatIZ+GVzmVg6b8Zy32pGybprObotyvEgvdL2w=";

  web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${pname}-web";
    inherit src version;
    sourceRoot = "${finalAttrs.src.name}/web";

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname version src sourceRoot;
      hash = "sha256-25Bg8sTeH/w25KdfwgZNoqBXz2d5c1QD5vGb33xpTCA=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
    ];

    env.ESBUILD_BINARY_PATH = lib.getExe (esbuild.override {
      buildGoModule = args: buildGoModule (args // rec {
        version = "0.17.19";
        src = fetchFromGitHub {
          owner = "evanw";
          repo = "esbuild";
          rev = "v${version}";
          hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
        };
        vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
      });
    });

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

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
  ];

  postInstall = lib.optionalString (!stdenvNoCC.hostPlatform.isDarwin) ''
    mv $out/bin/SyncYomi $out/bin/syncyomi
  '';

  meta = {
    description = "Open-source project to synchronize Tachiyomi manga reading progress and library across multiple devices";
    homepage = "https://github.com/SyncYomi/SyncYomi";
    changelog = "https://github.com/SyncYomi/SyncYomi/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eriedaberrie ];
    mainProgram = "syncyomi";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
