{
  lib,
  buildGoModule,
  fetchFromGitHub,
  findutils,
  go,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tsgolint";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "tsgolint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gby8JW3bwVOIuNgLCIIt0y3egdljrR5cgbqAGqqqzpI=";
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
    (finalAttrs.src + "/patches/0004-feat-improve-panic-message-for-extracting-TS-extensi.patch")
    (finalAttrs.src + "/patches/0005-fix-early-return-from-invalid-tsconfig-for-better-er.patch")
  ];

  postPatch =
    # We don't want to build with go.work, so we add the replacement to
    # the local module to the go.mod instead.
    ''
      popd
      ${lib.getExe go} mod edit --replace=github.com/microsoft/typescript-go=./typescript-go
    ''
    +
    # From justfile's "init" target upstream.
    ''
      rm go.work{,.sum}
      mkdir -p internal/collections && find ./typescript-go/internal/collections -type f ! -name '*_test.go' -exec cp {} internal/collections/ \;
    '';

  proxyVendor = true;
  vendorHash = "sha256-pCmPL0OVwclCV5riL8wozCiQA2zRDafBKTxdkt/q3ns=";

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
