{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  findutils,
  go_1_26,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "tsgolint";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "tsgolint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bY5oDaaKMu4KmGQFT3MyzNNKZWC8PVSRjAgWYhPVE2s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ findutils ];

  prePatch = ''
    pushd typescript-go
  '';

  # These patches are applied to the typescript-go submodule in justfile's "init" target upstream.
  patches = [
    (finalAttrs.src + "/patches/0001-Parallel-readDirectory-visitor.patch")
    (finalAttrs.src + "/patches/0002-Adapt-project-service-for-single-run-mode.patch")
    (finalAttrs.src + "/patches/0003-patch-expose-more-functions-via-the-shim-with-type-f.patch")
    (finalAttrs.src + "/patches/0004-fix-early-return-from-invalid-tsconfig-for-better-er.patch")
    (finalAttrs.src + "/patches/0005-fix-collections-avoid-internal-json-import-in-ordere.patch")
    (finalAttrs.src + "/patches/0006-perf-vfs-cache-ReadFile-results-in-cachedvfs.patch")
  ];

  postPatch =
    # We don't want to build with go.work, so we add the replacement to
    # the local module to the go.mod instead.
    ''
      popd
      ${lib.getExe go_1_26} mod edit --replace=github.com/microsoft/typescript-go=./typescript-go
    ''
    +
    # From justfile's "init" target upstream.
    ''
      rm go.work{,.sum}
      mkdir -p internal/collections && find ./typescript-go/internal/collections -type f ! -name '*_test.go' -exec cp {} internal/collections/ \;
    '';

  proxyVendor = true;
  vendorHash = "sha256-Mb78gEN582QFTRTBefdAz8Yly2vB3zbPyViRnA1V3wI=";

  subPackages = [ "cmd/tsgolint" ];

  env.GOEXPERIMENT = "greenteagc";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Type aware linting for oxlint";
    homepage = "https://github.com/oxc-project/tsgolint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
    mainProgram = "tsgolint";
  };
})
