{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,

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
  version = "1.84.3";
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
    hash = "sha256-0HvUNpyi6xzS3PtbgMvh6bLRhV77CZRrVSKGMr7JtbE=";
  };

  vendorHash = "sha256-QBYCMOWQOBCt+69NtJtluhTZIOiBWcQ78M9Gbki6bN0=";

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
    "cmd/get-authkey"
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

    # several tests hang, but keeping the file for tsnet/packet_filter_test.go
    # packet_filter_test issue: https://github.com/tailscale/tailscale/issues/16051
    substituteInPlace tsnet/tsnet_test.go \
      --replace-fail 'func Test' 'func skippedTest'
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

          # flaky: https://github.com/tailscale/tailscale/issues/7030
          "TestConcurrent"

          # flaky: https://github.com/tailscale/tailscale/issues/11762
          "TestTwoDevicePing"

          # timeout 10m
          "TestTaildropIntegration"
          "TestTaildropIntegration_Fresh"

          # context deadline exceeded
          "TestPacketFilterFromNetmap"

          # flaky: https://github.com/tailscale/tailscale/issues/15348
          "TestSafeFuncHappyPath"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # syscall default route interface en0 differs from netstat
          "TestLikelyHomeRouterIPSyscallExec" # net/netmon

          # Even with __darwinAllowLocalNetworking this doesn't work.
          # panic: write udp [::]:59507->127.0.0.1:50830: sendto: operation not permitted
          "TestUDP" # net/socks5

          # portlist_test.go:81: didn't find ephemeral port in p2 53643
          "TestPoller" # portlist

          # Fails only on Darwin, succeeds on other tested platforms.
          "TestOnTailnetDefaultAutoUpdate"
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
      ryan4yin
    ];
  };
}
