{
  lib,
  stdenv,

  buildGo127Module,
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
  # check phase tooling
  gitMinimal,
  # check phase tooling - darwin
  unixtools,

  nixosTests,
  tailscale-nginx-auth,
}:

buildGo127Module (finalAttrs: {
  pname = "tailscale";
  version = "1.104.1";

  outputs = [
    "out"
    "derper"
  ];

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f80GVxstQrr8ENP1bseoIpLflQ+QYEisDF8PHzTs7Lg=";
  };

  vendorHash = "sha256-f9abuyk1qvVr6MPpfmHay6p/U/+8flm1SBmHGjZa1aU=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeCheckInputs = [
    # misc/git_hook/githook tests create a scratch repository
    gitMinimal
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    unixtools.netstat
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/derper"
    "cmd/derpprobe"
    "cmd/tailscaled"
    "cmd/get-authkey"
  ];

  excludedPackages = [
    # Exclude integration tests which fail to work and require additional tooling
    "tstest/integration"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${finalAttrs.version}"
    "-X tailscale.com/version.shortStamp=${finalAttrs.version}"
  ];

  tags = [
    "ts_include_cli"
  ];

  # Remove vendored tooling to ensure it's not used; also avoids some unnecessary tests
  preBuild = ''
    rm -rf ./tool
  '';

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  # Tests are in the `go-*` passthru derivations because they are flaky, frequently causing build failures.
  doCheck = false;

  preCheck = ''
    # feed in all tests for testing
    # subPackages above limits what is built to just what we
    # want but also limits the tests
    unset subPackages
  '';

  checkFlags =
    let
      skippedTests = [
        # dislikes vendoring
        "TestPackageDocs" # .
        # tries to start tailscaled
        "TestContainerBoot" # cmd/containerboot

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
        "TestExitCodePassthrough" # ssh/tailssh
        # wants users alice & ubuntu
        "TestMultipleRecorders" # ssh/tailssh
        "TestSSHAuthFlow" # ssh/tailssh
        "TestSSHRecordingCancelsSessionsOnUploadFailure" # ssh/tailssh
        "TestSSHRecordingNonInteractive" # ssh/tailssh

        # test for a dev util which helps to fork golang.org/x/crypto/acme
        # not necessary and fails to match
        "TestSyncedToUpstream" # tempfork/acme

        # flaky: https://github.com/tailscale/tailscale/issues/11762
        "TestTwoDevicePing"

        # timeout 10m
        "TestTaildropIntegration"
        "TestTaildropIntegration_Fresh"

        # Requires `go` to be installed with the `go tool` system which we don't use
        "TestGoVersion"

        # Fails because we vendor dependencies
        "TestLicenseHeaders"

        # Runs `go test -race`, which requires cgo, but we build with CGO_ENABLED=0
        "TestRaceAttributedToPassingTest" # cmd/testwrapper
        "TestRaceSuppressesFlakyRetry" # cmd/testwrapper

        # Uses testing/synctest which spawns goroutines that block on syscalls
        # incompatible with synctest's bubble mechanism
        "TestDNSTrampleRecovery"
        "TestOnPolicyChangeSkipsPreAuthConns" # ssh/tailssh
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

        # Fails due to UNIX domain socket path limits in the Nix build environment.
        # Likely we could do something to make the paths shorter.
        "TestProtocolQEMU"
        "TestProtocolUnixDgram"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
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
    substituteInPlace ./cmd/tailscaled/tailscale-wait-online.service --replace-fail "/usr/bin" "$out/bin"
    install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/{tailscaled.service,tailscale-online.target,tailscale-wait-online.service}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    local INSTALL="$out/bin/tailscale"
    installShellCompletion --cmd tailscale \
      --bash <($out/bin/tailscale completion bash) \
      --fish <($out/bin/tailscale completion fish) \
      --zsh <($out/bin/tailscale completion zsh)
  '';

  passthru.tests =
    let
      # Top-level directories whose Go tests get a derivation of their own.
      # Packages in every other directory are tested by `go-other`.
      goTestGroups = [
        "client"
        "cmd"
        "control"
        "derp"
        "drive"
        "feature"
        "ipn"
        "k8s-operator"
        "kube"
        "net"
        "ssh"
        "tsnet"
        "tstest"
        "tsweb"
        "types"
        "util"
        "wgengine"
      ];

      mkGoTests =
        name: pattern: excludedDirs:
        let
          excludeRegex = "^tailscale\\.com/(${
            lib.concatMapStringsSep "|" lib.escapeRegex (
              [ "tool" ] ++ finalAttrs.excludedPackages ++ excludedDirs
            )
          })(/|$)";
        in
        finalAttrs.finalPackage.overrideAttrs (old: {
          pname = "${old.pname}-go-tests-${name}";
          outputs = [ "out" ];
          dontBuild = true;
          doCheck = true;

          # A single `go test` invocation for the whole group, so that every
          # failing package is reported rather than only the first.
          checkPhase = ''
            runHook preCheck
            # We do not set trimpath for tests, in case they reference test assets
            export GOFLAGS=''${GOFLAGS//-trimpath/}

            tags=${lib.escapeShellArg (lib.concatStringsSep "," finalAttrs.tags)}
            packages=$(go list -tags="$tags" ${pattern} | { grep -v -E ${lib.escapeShellArg excludeRegex} || true; })
            if [[ -z $packages ]]; then
              echo "error: no Go packages matched ${pattern}" >&2
              exit 1
            fi

            go test -vet=off -p "$NIX_BUILD_CORES" -tags="$tags" \
              -ldflags=${lib.escapeShellArg (toString finalAttrs.ldflags)} \
              $checkFlags $packages

            runHook postCheck
          '';

          installPhase = ''
            runHook preInstall
            touch $out
            runHook postInstall
          '';
          postInstall = "";
        });
    in
    {
      inherit (nixosTests) headscale;
      inherit tailscale-nginx-auth;
      go-other = mkGoTests "other" "./..." goTestGroups;
    }
    // lib.genAttrs' goTestGroups (
      dir: lib.nameValuePair "go-${dir}" (mkGoTests dir "./${dir}/..." [ ])
    );

  meta = {
    homepage = "https://tailscale.com";
    description = "Node agent for Tailscale, a mesh VPN built on WireGuard";
    changelog = "https://tailscale.com/changelog#client";
    license = lib.licenses.bsd3;
    mainProgram = "tailscale";
    maintainers = with lib.maintainers; [
      mbaillie
      jk
      mfrw
      philiptaron
      pyrox0
      ryan4yin
    ];
  };
})
