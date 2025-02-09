{ lib, stdenv, buildGoModule, fetchFromGitHub, buildFHSEnv, installShellFiles, go-task }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "0.34.2";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = version;
      hash = "sha256-X7vrcaJkVqzZoaIFLWJhhdlgRpckLG69uVmUUZd/XXY=";
    };

    nativeBuildInputs = [
      installShellFiles
    ];

    nativeCheckInputs = [
      go-task
    ];

    subPackages = [ "." ];

    vendorHash = "sha256-cr5D7QDh65xWZJ4gq32ehklwrHWyQEWW/FZZ4gPTJBk=";

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
        --replace "go test" "go test -p $NIX_BUILD_CORES -skip '(${lib.concatStringsSep "|" skipTests})'"
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

    postInstall = ''
      export HOME="$(mktemp -d)"
      for s in {bash,zsh,fish}; do
        $out/bin/arduino-cli completion $s > completion.$s
        installShellCompletion --cmd arduino-cli --$s completion.$s
      done
      unset HOME
    '';

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "Arduino from the command line";
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
      cp -r ${pkg.outPath}/share $out/share
    '';
    passthru.pureGoPkg = pkg;

    targetPkgs = pkgs: with pkgs; [
      zlib
    ];
  }
else
  pkg
