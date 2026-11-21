{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  fetchzip,
  gitMinimal,
  which,
}:

let
  # TODO: build from source
  dashboardVersion = "8.5.3-1319283e";
  dashboardEmbeddedAssets = fetchzip {
    url = "https://github.com/pingcap/tidb-dashboard/releases/download/v${dashboardVersion}/embedded-assets-golang.zip";
    hash = "sha256-+F4/PVHPL9AyXlPW1xcQ9jH1Pfdi+r7jvmx+Ww5lKTI=";
    stripRoot = false;
  };
in
buildGo125Module (finalAttrs: {
  pname = "tikv-pd";
  version = "8.5.5";

  src = fetchFromGitHub {
    owner = "tikv";
    repo = "pd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2o5qpsRlSJql30FkRsgX91axjFwUT6Uqs5orpeu549U=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"

      releaseVersion="v${finalAttrs.version}"
      buildTs="$(date -u -d @"$SOURCE_DATE_EPOCH" '+%Y-%m-%d %I:%M:%S')"
      gitHash="$(git rev-parse HEAD)"
      gitBranch="$releaseVersion"

      substituteInPlace Makefile \
        --replace-fail "\$(shell git describe --tags --dirty --always)" "$releaseVersion" \
        --replace-fail "\$(shell date -u '+%Y-%m-%d %I:%M:%S'" "$buildTs" \
        --replace-fail "\$(shell git rev-parse HEAD)" "$gitHash" \
        --replace-fail "\$(shell git rev-parse --abbrev-ref HEAD)" "$gitBranch" \
        --replace-fail "\$(shell git describe --tags --dirty --always)" "$releaseVersion"

      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  postPatch = ''
    cp ${dashboardEmbeddedAssets}/embedded_assets_handler.go pkg/dashboard/uiserver/embedded_assets_handler.go
    patchShebangs scripts/*.sh
  '';

  vendorHash = "sha256-oH5/L68DMysbTHLeVgNuX9jVG9y9mFxLrTC6NDHmxA4=";
  proxyVendor = true;
  modPostBuild = ''
    go -C tools mod download
  '';

  nativeBuildInputs = [
    gitMinimal
    which
  ];

  buildPhase = ''
    runHook preBuild

    # TODO: Build tidb-dashboard from source, then set DASHBOARD=COMPILE
    GOFLAGS="-mod=mod -trimpath" make DASHBOARD=SKIP build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m0755 bin/pd-ctl $out/bin/pd-ctl
    install -m0755 bin/pd-server $out/bin/pd-server
    install -m0755 bin/pd-recover $out/bin/pd-recover

    runHook postInstall
  '';

  meta = {
    description = "Placement driver for TiKV";
    homepage = "https://github.com/tikv/pd";
    license = lib.licenses.asl20;
    mainProgram = "pd-server";
    maintainers = with lib.maintainers; [ definfo ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
