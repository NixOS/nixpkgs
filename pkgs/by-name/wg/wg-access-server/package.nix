{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  iptables,
  nixosTests,
  nodejs_22,
}:

buildGoModule (finalAttrs: {
  pname = "wg-access-server";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "freifunkMUC";
    repo = "wg-access-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x4QNEn5SR6D1YIiv+mKnQlZ94jZ7BrdIxiLxBqhtBjg=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-pjQeF1+1gr/0pF76KNdK7GDX3pYBTqqY3xbJeMLsJIM=";

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

    nodejs = nodejs_22;

    npmDepsHash = "sha256-UntV5+9E2lyp8IQGKbbnBNdd0JLvM5NsfkLvCSOgyGo=";

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
  };

  meta = {
    description = "All-in-one WireGuard VPN solution with a web ui for connecting devices";
    homepage = "https://github.com/freifunkMUC/wg-access-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "wg-access-server";
  };
})
