{
  lib,
  buildGoModule,
  fetchgit,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "wireguard-go";
  version = "0.0.20250522";

  src = fetchgit {
    url = "https://git.zx2c4.com/wireguard-go";
    tag = finalAttrs.version;
    hash = "sha256-GRr8NKKb4SHd0WxmNL84eiofFHcauDDmSyNNrXermcA=";
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

  vendorHash = "sha256-sCajxTV26jjlmgmbV4GG6hg9NkLGS773ZbFyKucvuBE=";

  subPackages = [ "." ];

  ldflags = [ "-s" ];

  # No tests besides the formatting one are in root.
  # We can't override subPackages per-phase (and we don't
  # want to needlessly build packages that have build
  # constraints), so just use the upstream Makefile (that
  # runs `go test ./...`) to actually run the tests.
  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    make test
    runHook postCheck
  '';

  # Tests require networking.
  __darwinAllowLocalNetworking = finalAttrs.doCheck;

  postInstall = ''
    mv $out/bin/wireguard $out/bin/wireguard-go
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Userspace Go implementation of WireGuard";
    homepage = "https://git.zx2c4.com/wireguard-go/about/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kirelagin
      winter
      zx2c4
    ];
    mainProgram = "wireguard-go";
  };
})
