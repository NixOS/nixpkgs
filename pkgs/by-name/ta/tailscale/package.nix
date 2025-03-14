{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  fetchpatch,

  makeWrapper,
  installShellFiles,
  # runtime tooling - linux
  getent,
  iproute2,
  iptables,
  shadow,
  procps,
  # runtime tooling - darwin
  lsof,
  # check phase tooling - darwin
  unixtools,

  nixosTests,
  tailscale-nginx-auth,
}:

let
  version = "1.80.3";
in
buildGoModule {
  pname = "tailscale";
  inherit version;

  outputs = [
    "out"
    "derper"
  ];

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    hash = "sha256-UOz2EAUlYZx2XBzw8hADO0ti9bgwz19MTg60rSefSB8=";
  };

  patches = [
    # Fix "tailscale ssh" when built with ts_include_cli tag
    # https://github.com/tailscale/tailscale/pull/12109
    (fetchpatch {
      url = "https://github.com/tailscale/tailscale/commit/325ca13c4549c1af58273330744d160602218af9.patch";
      hash = "sha256-SMwqZiGNVflhPShlHP+7Gmn0v4b6Gr4VZGIF/oJAY8M=";
    })
    # Fix build with Go 1.24
    (fetchpatch {
      url = "https://github.com/tailscale/tailscale/commit/836c01258de01a38fdd267957eeedab7faf0f4f2.patch";
      includes = ["cmd/testwrapper/*" "cmd/tsconnect/*"];
      hash = "sha256-e+IQB2nlJmJCzCTbASiqX2sXKmwVNXb+d87DdwTdJ+I=";
    })
  ];

  vendorHash = "sha256-81UOjoC5GJqhNs4vWcQ2/B9FMaDWtl0rbuFXmxbu5dI=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    unixtools.netstat
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/derper"
    "cmd/derpprobe"
    "cmd/tailscaled"
    "cmd/tsidp"
  ];

  excludedPackages = [
    # exlude integration tests which fail to work
    # and require additional tooling
    "tstest/integration"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${version}"
    "-X tailscale.com/version.shortStamp=${version}"
  ];

  tags = [
    "ts_include_cli"
  ];

  # remove vendored tooling to ensure it's not used
  # also avoids some unnecessary tests
  preBuild = ''
    rm -rf ./tool
  '';

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # feed in all tests for testing
    # subPackages above limits what is built to just what we
    # want but also limits the tests
    unset subPackages

    # several tests hang
    rm tsnet/tsnet_test.go
  '';

  checkFlags =
    let
      skippedTests =
        [
          # dislikes vendoring
          "TestPackageDocs" # .
          # tries to start tailscaled
          "TestContainerBoot" # cmd/containerboot

          # just part of a tool which generates yaml for k8s CRDs
          # requires helm
          "Test_generate" # cmd/k8s-operator/generate
          # self reported potentially flakey test
          "TestConnMemoryOverhead" # control/controlbase

          # interacts with `/proc/net/route` and need a default route
          "TestDefaultRouteInterface" # net/netmon
          "TestRouteLinuxNetlink" # net/netmon
          "TestGetRouteTable" # net/routetable

          # remote udp call to 8.8.8.8
          "TestDefaultInterfacePortable" # net/netutil

          # launches an ssh server which works when provided openssh
          # also requires executing commands but nixbld user has /noshell
          "TestSSH" # ssh/tailssh
          # wants users alice & ubuntu
          "TestMultipleRecorders" # ssh/tailssh
          "TestSSHAuthFlow" # ssh/tailssh
          "TestSSHRecordingCancelsSessionsOnUploadFailure" # ssh/tailssh
          "TestSSHRecordingNonInteractive" # ssh/tailssh

          # test for a dev util which helps to fork golang.org/x/crypto/acme
          # not necessary and fails to match
          "TestSyncedToUpstream" # tempfork/acme
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # syscall default route interface en0 differs from netstat
          "TestLikelyHomeRouterIPSyscallExec" # net/netmon

          # Even with __darwinAllowLocalNetworking this doesn't work.
          # panic: write udp [::]:59507->127.0.0.1:50830: sendto: operation not permitted
          "TestUDP" # net/socks5

          # portlist_test.go:81: didn't find ephemeral port in p2 53643
          "TestPoller" # portlist
        ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall =
    ''
      ln -s $out/bin/tailscaled $out/bin/tailscale
      moveToOutput "bin/derper" "$derper"
      moveToOutput "bin/derpprobe" "$derper"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapProgram $out/bin/tailscaled \
        --prefix PATH : ${
          lib.makeBinPath [
            # Uses lsof only on macOS to detect socket location
            # See tailscale safesocket_darwin.go
            lsof
          ]
        }
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/tailscaled \
        --prefix PATH : ${
          lib.makeBinPath [
            getent
            iproute2
            iptables
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
    inherit tailscale-nginx-auth;
  };

  meta = {
    homepage = "https://tailscale.com";
    description = "Node agent for Tailscale, a mesh VPN built on WireGuard";
    changelog = "https://github.com/tailscale/tailscale/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    mainProgram = "tailscale";
    maintainers = with lib.maintainers; [
      mbaillie
      jk
      mfrw
      pyrox0
    ];
  };
}
