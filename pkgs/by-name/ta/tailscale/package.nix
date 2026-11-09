{
  lib,
  stdenv,

  buildGo127Module,
  fetchFromGitHub,
  fetchpatch2,

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
  openssh,
  util-linux,
  # check phase tooling - darwin
  unixtools,

  nixosTests,
  tailscale-nginx-auth,
}:

buildGo127Module (finalAttrs: {
  pname = "tailscale";
  version = "1.104.5";

  outputs = [
    "out"
    "derper"
  ];

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aq4pBe75wNRFDEa3kSDa/pBLsZws5mOUOjHDUycpmXM=";
  };

  patches = [
    # ssh/tailssh: accept an empty --groups= in the incubator
    # https://github.com/tailscale/tailscale/pull/22160
    (fetchpatch2 {
      url = "https://github.com/tailscale/tailscale/commit/ebbf2d1980466043b3a9a41cbd6d7e50ab2da02b.patch?full_index=1";
      hash = "sha256-W5gdLkK+Es5boZ83psjGo4ELUWc/Y+uidVLDnNFvYIs=";
    })
    # drive/driveimpl/compositedav: don't run ttlcache cleanup goroutines
    # https://github.com/tailscale/tailscale/pull/21906
    (fetchpatch2 {
      url = "https://github.com/tailscale/tailscale/commit/a6cffd0a6d11ef8aa3a0ca0ddc15879d0845605d.patch?full_index=1";
      hash = "sha256-wzWVZQvH28cbmUxoXq4Qq4xD6eR/YgNbCTrySKQ2UDg=";
    })
  ];

  vendorHash = "sha256-RvaouD88naVNOPJBVcqMaAn+ovjXI4g83ShCdRiR5/Q=";

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
        # interacts with `/proc/net/route` and need a default route
        "TestDefaultRouteInterface" # net/netmon
        "TestRouteLinuxNetlink" # net/netmon
        "TestGetRouteTable" # net/routetable
        "TestDeriveBindhost" # tstest/integration/vms

        # remote udp call to 8.8.8.8
        "TestDefaultInterfacePortable" # net/netutil

        # test for a dev util which helps to fork golang.org/x/crypto/acme
        # not necessary and fails to match
        "TestSyncedToUpstream" # tempfork/acme

        # Requires `go` to be installed with the `go tool` system which we don't use
        "TestGoVersion"

        # Agent forwarding dirs are only removed from a root-owned /tmp.
        "TestAgentForwardDirCleanup" # ssh/tailssh
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
      # Directories whose Go tests get a derivation of their own, mapped to
      # attributes (or a function of the previous attributes) to override in
      # it. A directory nested in another group is tested only by its own
      # group. Packages in every other directory are tested by `go-other`.
      goTestGroups = {
        client = { };
        cmd = {
          # TestContainerBoot embeds these as fake tailscale{,d} binaries.
          preCheck = ''
            chmod +x cmd/containerboot/test_tailscale{,d}.sh
            patchShebangs cmd/containerboot/test_tailscale{,d}.sh
          '';
        };
        # TestRace* run `go test -race`, which needs cgo.
        "cmd/testwrapper" = old: {
          env = old.env // {
            CGO_ENABLED = 1;
          };
        };
        control = { };
        derp = { };
        drive = { };
        feature = { };
        ipn = { };
        k8s-operator = { };
        kube = { };
        net = { };
        ssh = old: {
          # TestSSH and TestExitCodePassthrough drive the server with an ssh client;
          # TestShutdownWithLingeringDescendant runs `setsid`.
          nativeCheckInputs =
            old.nativeCheckInputs ++ [ openssh ] ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linux ];
          env = old.env // {
            # Skip the TestSSH subtests that upstream skips in its own CI;
            # TestSSH/env expects sessions to start in $HOME, which tailssh
            # only does if /usr/bin/true or /bin/true exists.
            CI = "true";
          };
          # SSH sessions otherwise get an FHS-style default PATH, which finds
          # nothing in the sandbox.
          preCheck = ''
            export TAILSCALE_SSH_DEFAULT_PATH="$PATH"

            # The session monitor tests run children by absolute FHS paths, and
            # with an empty environment, so give their shell the build's PATH.
            # Once `ls` is found, the shell execs it in place unless it is not
            # the last command, and lists the fd `ls` opens on /proc/$$/fd.
            makeWrapper /bin/sh "$TMPDIR/sh" --set PATH "$PATH"
            substituteInPlace ssh/tailssh/{fdleak,monitor,monitor_rpc,monitor_teardown_linux,monitor_termination,sessmonitor,tailssh_exitcodes,tailssh_frameorder}_test.go \
              --replace-fail '"/bin/sh"' "\"$TMPDIR/sh\""
            substituteInPlace ssh/tailssh/{monitor,monitor_lifecycle,monitor_teardown_linux,session_termination,sessmonitor}_test.go \
              --replace-fail '"/bin/sleep"' "\"$(type -P sleep)\""
            substituteInPlace ssh/tailssh/monitor_test.go \
              --replace-fail '"/usr/bin/id"' "\"$(type -P id)\"" \
              --replace-fail 'ls -1 /proc/$$/fd"' 'ls -1 /proc/$$/fd; :"'
          '';
        };
        tsnet = { };
        tstest = { };
        tsweb = { };
        types = { };
        util = { };
        wgengine = { };
      };
      goTestDirs = lib.attrNames goTestGroups;

      mkGoTests =
        name: pattern: excludedDirs: overrides:
        let
          excludeRegex = "^tailscale\\.com/(${
            lib.concatMapStringsSep "|" lib.escapeRegex ([ "tool" ] ++ excludedDirs)
          })(/|$)";
        in
        finalAttrs.finalPackage.overrideAttrs (
          old:
          {
            pname = "${old.pname}-go-tests-${name}";
            inherit (finalAttrs) goModules;
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
          }
          // lib.toFunction overrides old
        );
    in
    {
      inherit (nixosTests) headscale;
      inherit tailscale-nginx-auth;
      go-other = mkGoTests "other" "./..." goTestDirs {
        # TestLicenseHeaders and TestPackageDocs walk the source tree and
        # would check the vendored dependencies too. `filepath.Walk` does not
        # follow symlinks, so link the vendor directory instead of copying it.
        preCheck = ''
          chmod -R u+w vendor
          rm -rf vendor
          ln -s "$goModules" vendor
        '';
      };
    }
    // lib.mapAttrs' (
      dir: overrides:
      let
        name = lib.replaceStrings [ "/" ] [ "-" ] dir;
        nestedDirs = lib.filter (lib.hasPrefix "${dir}/") goTestDirs;
      in
      lib.nameValuePair "go-${name}" (mkGoTests name "./${dir}/..." nestedDirs overrides)
    ) goTestGroups;

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
