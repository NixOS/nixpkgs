{ lib, stdenv, buildGoModule, fetchFromGitHub, buildFHSEnv, installShellFiles, go-task }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "1.0.1";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-3VXc0Ksv6swmKEClNF5RRjX68RFLg2IRdBwcVgI5Syo=";
    };

    nativeBuildInputs = [
      installShellFiles
    ];

    nativeCheckInputs = [
      go-task
    ];

    subPackages = [ "." ];

    vendorHash = "sha256-lB/PfUZFL5+YBcAhrMMV2ckAHPhtW2SL3/zM3L4XGVc=";

    postPatch = let
      skipTests = [
        # tries to "go install"
        "TestDummyMonitor"
        # try to Get "https://downloads.arduino.cc/libraries/library_index.tar.bz2"
        "TestDownloadAndChecksums"
        "TestParseArgs"
        "TestParseReferenceCores"
        "TestPlatformSearch"
        "TestPlatformSearchSorting"
      ];
    in ''
      substituteInPlace Taskfile.yml \
        --replace-fail "go test" "go test -p $NIX_BUILD_CORES -skip '(${lib.concatStringsSep "|" skipTests})'"
    '';

    doCheck = stdenv.isLinux;

    checkPhase = ''
      runHook preCheck
      task go:test
      runHook postCheck
    '';

    ldflags = [
      "-s" "-w" "-X github.com/arduino/arduino-cli/version.versionString=${version}" "-X github.com/arduino/arduino-cli/version.commit=unknown"
    ] ++ lib.optionals stdenv.isLinux [ "-extldflags '-static'" ];

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      export HOME="$(mktemp -d)"
      installShellCompletion --cmd arduino-cli \
        --bash <($out/bin/arduino-cli completion bash) \
        --zsh <($out/bin/arduino-cli completion zsh) \
        --fish <($out/bin/arduino-cli completion fish)
      unset HOME
    '';

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "Arduino from the command line";
      mainProgram = "arduino-cli";
      changelog = "https://github.com/arduino/arduino-cli/releases/tag/${version}";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ ryantm ];
    };

  };

in
if stdenv.isLinux then
# buildFHSEnv is needed because the arduino-cli downloads compiler
# toolchains from the internet that have their interpreters pointed at
# /lib64/ld-linux-x86-64.so.2
  buildFHSEnv
  {
    inherit (pkg) name meta;

    runScript = "${pkg.outPath}/bin/arduino-cli";

    extraInstallCommands = ''
      mv $out/bin/$name $out/bin/arduino-cli
    '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      cp -r ${pkg.outPath}/share $out/share
    '';
    passthru.pureGoPkg = pkg;

    targetPkgs = pkgs: with pkgs; [
      zlib
    ];
  }
else
  pkg
