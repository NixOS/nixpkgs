{
  lib,
  buildGoModule,
  fetchFromGitHub,

  clang,
  pkg-config,

  elfutils,
  libbpf,
  zlib,
  zstd,

  nixosTests,
  testers,
  tracee,
  makeWrapper,
}:

buildGoModule rec {
  pname = "tracee";
  version = "0.23.2";

  # src = /home/tim/repos/tracee;
  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "tracee";
    # project has branches and tags of the same name
    tag = "v${version}";
    hash = "sha256-Rf1pa9e6t002ltg40xZZVpE5OL9Vl02Xcn2Ux0To408=";
  };
  vendorHash = "sha256-2+4UN9WB6eGzedogy5dMvhHj1x5VeUUkDM0Z28wKQgM=";

  patches = [
    ./0001-fix-do-not-build-libbpf.patch
  ];

  enableParallelBuilding = true;
  # needed to build bpf libs
  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  nativeBuildInputs = [
    clang
    pkg-config
  ];
  buildInputs = [
    elfutils
    libbpf
    zlib.dev
    zstd.dev
  ];

  makeFlags = [
    "RELEASE_VERSION=v${version}"
    "GO_DEBUG_FLAG=-s -w"
    # don't actually need git but the Makefile checks for it
    "CMD_GIT=echo"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p ./dist
    make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} bpf all
    runHook postBuild
  '';

  # tests require a separate go module
  # integration tests are ran within a nixos vm
  # see passthru.tests.integration
  doCheck = false;

  outputs = [
    "out"
    "lib"
    "share"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $lib/lib/tracee $share/share/tracee

    mv ./dist/{tracee,signatures} $out/bin/
    mv ./dist/tracee.bpf.o $lib/lib/tracee/
    mv ./cmd/tracee-rules/templates $share/share/tracee/

    runHook postInstall
  '';

  passthru.tests = {
    integration = nixosTests.tracee;
    integration-test-cli = import ./integration-tests.nix { inherit lib tracee makeWrapper; };
    version = testers.testVersion {
      package = tracee;
      version = "v${version}";
      command = "tracee version";
    };
  };

  meta = with lib; {
    homepage = "https://aquasecurity.github.io/tracee/latest/";
    changelog = "https://github.com/aquasecurity/tracee/releases/tag/v${version}";
    description = "Linux Runtime Security and Forensics using eBPF";
    mainProgram = "tracee";
    longDescription = ''
      Tracee is a Runtime Security and forensics tool for Linux. It is using
      Linux eBPF technology to trace your system and applications at runtime,
      and analyze collected events to detect suspicious behavioral patterns. It
      is delivered as a Docker image that monitors the OS and detects suspicious
      behavior based on a pre-defined set of behavioral patterns.
    '';
    license = with licenses; [
      # general license
      asl20
      # pkg/ebpf/c/*
      gpl2Plus
    ];
    maintainers = with maintainers; [ jk ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    outputsToInstall = [
      "out"
      "share"
    ];
  };
}
