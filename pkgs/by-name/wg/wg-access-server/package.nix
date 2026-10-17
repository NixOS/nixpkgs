{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  iptables,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "wg-access-server";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "freifunkMUC";
    repo = "wg-access-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NnIvVgshrvZiSsXXCjluTAVy9T0MthP9uJHJaK0QHWU=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-mcyQtBS9185GQJIKbO/92v8bxrF4xVyqKbeWYem8QF4=";

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [ "-skip=TestDNSProxy_ServeDNS" ];

  ui = buildNpmPackage {
    inherit (finalAttrs) version src;
    pname = "wg-access-server-ui";

    npmDepsHash = "sha256-2jFr3W1XwiN2q2YUzWAMB6yDIz8Gp9qwQYG2QlFf6vY=";

    sourceRoot = "${finalAttrs.src.name}/website";

    installPhase = ''
      mv build $out
    '';
  };

  postPatch = ''
    substituteInPlace internal/services/website_router.go \
        --replace-fail 'website/build' "${finalAttrs.ui}"
  '';

  preBuild = ''
    VERSION=v${finalAttrs.version} go generate buildinfo/buildinfo.go
  '';

  postInstall = ''
    mkdir -p $out/
    wrapProgram  $out/bin/wg-access-server \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru = {
    tests = { inherit (nixosTests) wg-access-server; };
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "ui"
      ];
    };
  };

  meta = {
    description = "All-in-one WireGuard VPN solution with a web ui for connecting devices";
    homepage = "https://github.com/freifunkMUC/wg-access-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "wg-access-server";
  };
})
