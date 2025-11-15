{
  lib,
  buildGoModule,
  fetchzip,
  testers,
  wireguard-go,
}:

buildGoModule (
  finalAttrs:
  let
    version = "0.0.20250522";
  in
  {
    pname = "wireguard-go";
    inherit version;

    src = fetchzip {
      url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
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

    passthru.tests.version = testers.testVersion {
      package = wireguard-go;
      version = "v${version}";
    };

    meta = with lib; {
      description = "Userspace Go implementation of WireGuard";
      homepage = "https://git.zx2c4.com/wireguard-go/about/";
      license = licenses.mit;
      maintainers = with maintainers; [
        kirelagin
        winter
        zx2c4
      ];
      mainProgram = "wireguard-go";
    };
  }
)
