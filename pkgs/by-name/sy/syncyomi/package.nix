{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildGoModule,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  esbuild,
}:
let
  lockedEsbuild = esbuild.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "0.19.11";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${finalAttrs.version}";
        hash = "sha256-NUwjzOpHA0Ijuh0E69KXx8YVS5GTnKmob9HepqugbIU=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    }
  );
in
buildGoModule (finalAttrs: {
  pname = "syncyomi";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "SyncYomi";
    repo = "SyncYomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pU3zxzixKoYnJsGpfvC/SVWIu0adsaiiVcLn0IZe64w=";
  };

  vendorHash = "sha256-fzPEljXFskr1/qzTsnASFNNc+8vA7kqO21mhMqwT44w=";

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
      fetcherVersion = 1;
      hash = "sha256-Gg4nOxqWb692GvvwE7AJKQzGrrLLW7haaooEkUZW7FQ=";
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

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (!stdenvNoCC.hostPlatform.isDarwin) ''
    mv $out/bin/SyncYomi $out/bin/syncyomi
  '';

  meta = {
    description = "Open-source project to synchronize Tachiyomi manga reading progress and library across multiple devices";
    homepage = "https://github.com/SyncYomi/SyncYomi";
    changelog = "https://github.com/SyncYomi/SyncYomi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eriedaberrie ];
    mainProgram = "syncyomi";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
