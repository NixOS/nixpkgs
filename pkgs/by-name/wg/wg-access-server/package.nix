{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  iptables,
  nixosTests,
}:

buildGoModule rec {
  pname = "wg-access-server";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "freifunkMUC";
    repo = "wg-access-server";
    rev = "v${version}";
    hash = "sha256-AhFqEmHrx9MCdjnB/YA3qU7KsaMyLO+vo53VWUrcL8I=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-YwFq0KxUctU3ElZBo/b68pyp4lJnFGL9ClKIwUzdngM=";

  CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [ "-skip=TestDNSProxy_ServeDNS" ];

  ui = buildNpmPackage {
    inherit version src;
    pname = "wg-access-server-ui";

    npmDepsHash = "sha256-04AkSDSKsr20Jbx5BJy36f8kWNlzzplu/xnoDTkU8OQ=";

    sourceRoot = "${src.name}/website";

    installPhase = ''
      mv build $out
    '';
  };

  postPatch = ''
    substituteInPlace internal/services/website_router.go \
        --replace-fail 'website/build' "${ui}"
  '';

  preBuild = ''
    VERSION=v${version} go generate buildinfo/buildinfo.go
  '';

  postInstall = ''
    mkdir -p $out/
    wrapProgram  $out/bin/wg-access-server \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru = {
    tests = { inherit (nixosTests) wg-access-server; };
  };

  meta = with lib; {
    description = "An all-in-one WireGuard VPN solution with a web ui for connecting devices";
    homepage = "https://github.com/freifunkMUC/wg-access-server";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio ];
    mainProgram = "wg-access-server";
  };
}
