{
  lib,
  stdenv,
  buildGo123Module,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  getent,
  iproute2,
  iptables,
  shadow,
  procps,
  nixosTests,
  installShellFiles,
}:

let
  version = "1.76.6";
in
buildGo123Module {
  pname = "tailscale";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    hash = "sha256-c44Fz/cYGN2nsjlaKln8ozjjS5jHSO/X9RMnHa37tJM=";
  };

  patches = [
    # Fix "tailscale ssh" when built with ts_include_cli tag
    # https://github.com/tailscale/tailscale/pull/12109
    (fetchpatch {
      url = "https://github.com/tailscale/tailscale/commit/325ca13c4549c1af58273330744d160602218af9.patch";
      hash = "sha256-SMwqZiGNVflhPShlHP+7Gmn0v4b6Gr4VZGIF/oJAY8M=";
    })
  ];

  vendorHash = "sha256-xCZ6YMJ0fqVzO+tKbCzF0ftV05NOB+lJbJBovLqlrtQ=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ] ++ [ installShellFiles ];

  CGO_ENABLED = 0;

  subPackages = [ "cmd/tailscaled" ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${version}"
    "-X tailscale.com/version.shortStamp=${version}"
  ];

  tags = [
    "ts_include_cli"
  ];

  doCheck = false;

  postInstall =
    ''
      ln -s $out/bin/tailscaled $out/bin/tailscale
    ''
    + lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/tailscaled \
        --prefix PATH : ${
          lib.makeBinPath [
            iproute2
            iptables
            getent
            shadow
          ]
        } \
        --suffix PATH : ${lib.makeBinPath [ procps ]}
      sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
      install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      local INSTALL="$out/bin/tailscale"
      installShellCompletion --cmd tailscale \
        --bash <($out/bin/tailscale completion bash) \
        --fish <($out/bin/tailscale completion fish) \
        --zsh <($out/bin/tailscale completion zsh)
    '';

  passthru.tests = {
    inherit (nixosTests) headscale;
  };

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "Node agent for Tailscale, a mesh VPN built on WireGuard";
    changelog = "https://github.com/tailscale/tailscale/releases/tag/v${version}";
    license = licenses.bsd3;
    mainProgram = "tailscale";
    maintainers = with maintainers; [
      mbaillie
      jk
      mfrw
      pyrox0
    ];
  };
}
