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
    rev = "12269c2761734b15625017d8565745096325392f";
    shortVer = "${finalAttrs.version} (${lib.substring 0 7 rev})";
  in
  {
    pname = "wireguard-go";
    version = "0-unstable-2023-12-11";

    src = fetchzip {
      url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${rev}.tar.xz";
      hash = "sha256-br7/dwr/e4HvBGJXh+6lWqxBUezt5iZNy9BFqEA1bLk=";
    };

    postPatch = ''
      # Skip formatting tests
      rm -f format_test.go

      # Inject version
      printf 'package main\n\nconst Version = "${shortVer}"' > version.go
    '';

    vendorHash = "sha256-RqZ/3+Xus5N1raiUTUpiKVBs/lrJQcSwr1dJib2ytwc=";

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
      version = "v${shortVer}";
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
