{ lib
, buildGoModule
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, iptables
}:

buildGoModule rec {
  pname = "wg-access-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "freifunkMUC";
    repo = "wg-access-server";
    rev = "v${version}";
    hash = "sha256-1X45XxdaeNETH3pwCzaOMQJL9CG4Ej/kXIUiVavm56A=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-ev2hvlugpHsCz6a1NQ7UXCgl8Mtq34G5+bBwpsEg1Ls=";

  CGO_ENABLED = 1;

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [ "-skip=TestDNSProxy_ServeDNS" ];

  ui = buildNpmPackage {
    inherit version src;
    pname = "wg-access-server-ui";

    npmDepsHash = "sha256-JMjojMxxNuay2/uQNuNgbZTQKMCyg6lWjfSfIYVeVzU=";

    sourceRoot = "${src.name}/website";

    installPhase = ''
      mkdir -p $out
      mv build/ $out/site
    '';
  };

  preBuild = ''
    VERSION=v${version} go generate buildinfo/buildinfo.go
  '';

  postInstall = ''
    mkdir -p $out/
    # include frontend so that the nixos module can use it.
    cp -r ${ui}/site/ $out/
    wrapProgram  $out/bin/wg-access-server \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru = {
    updateScript = ./update.sh;
  };


  meta = with lib; {
    description = "An all-in-one WireGuard VPN solution with a web ui for connecting devices";
    homepage = "https://github.com/freifunkMUC/wg-access-server";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio ];
    mainProgram = "wg-access-server";
  };
}
