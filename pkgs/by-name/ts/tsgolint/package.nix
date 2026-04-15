{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  findutils,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "tsgolint";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "tsgolint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U5+QgrYcuuUSsa8MCGFzBYFRyWdV5C3n9bahjv9Vg9Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ findutils ];

  prePatch = ''
    pushd typescript-go
  '';

  # These patches are applied to the typescript-go submodule in upstream justfile's "init" target.
  patches = [
    (finalAttrs.src + "/patches/0001-Adapt-project-service-for-single-run-mode.patch")
    (finalAttrs.src + "/patches/0002-patch-expose-more-functions-via-the-shim-with-type-f.patch")
    (finalAttrs.src + "/patches/0003-fix-early-return-from-invalid-tsconfig-for-better-er.patch")
    (finalAttrs.src + "/patches/0004-fix-collections-avoid-internal-json-import-in-ordere.patch")
    (finalAttrs.src + "/patches/0005-perf-vfs-cache-ReadFile-results-in-cachedvfs.patch")
  ];

  postPatch =
    # From upstream justfile's "init" target.
    ''
      popd
      mkdir -p internal/collections && find ./typescript-go/internal/collections -type f ! -name '*_test.go' -exec cp {} internal/collections/ \;
    '';

  proxyVendor = true;
  vendorHash = "sha256-iu2yQ4ZTSae49VgO/BYG3cEHhTtE4Q0g8L8KCAYARSw=";

  subPackages = [ "cmd/tsgolint" ];

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
