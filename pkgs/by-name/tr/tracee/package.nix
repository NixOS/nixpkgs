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

buildGoModule (finalAttrs: {
  pname = "tracee";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "tracee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TtSc5IfmDGu4BQv4HSumZEF5M2Gga/Svhri6tw3HybU=";
  };
  vendorHash = "sha256-c5w3lHReff5tD/l03moFfXOR7TzAG0OE/4ASYkjHUC4=";

  proxyVendor = true;

  preBuild = ''
    go work init . cmd/traceectl api common types
  '';

  overrideModAttrs = (
    _: {
      preBuild = ''
        go work init . cmd/traceectl api common types
      '';
    }
  );

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
    "RELEASE_VERSION=v${finalAttrs.version}"
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

    mv ./dist/{tracee,traceectl,signatures} $out/bin/
    mv ./dist/tracee.bpf.o $lib/lib/tracee/
    mv ./cmd/tracee-rules/templates $share/share/tracee/

    runHook postInstall
  '';

  passthru.tests = {
    integration = nixosTests.tracee;
    integration-test-cli = import ./integration-tests.nix { inherit lib tracee makeWrapper; };
    version = testers.testVersion {
      package = tracee;
      version = "v${finalAttrs.version}";
      command = "tracee version";
    };
  };

  meta = {
    homepage = "https://aquasecurity.github.io/tracee/latest/";
    changelog = "https://github.com/aquasecurity/tracee/releases/tag/v${finalAttrs.version}";
    description = "Linux Runtime Security and Forensics using eBPF";
    mainProgram = "tracee";
    longDescription = ''
      Tracee is a Runtime Security and forensics tool for Linux. It is using
      Linux eBPF technology to trace your system and applications at runtime,
      and analyze collected events to detect suspicious behavioral patterns. It
      is delivered as a Docker image that monitors the OS and detects suspicious
      behavior based on a pre-defined set of behavioral patterns.
    '';
    license = with lib.licenses; [
      # general license
      asl20
      # pkg/ebpf/c/*
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ jk ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    outputsToInstall = [
      "out"
      "share"
    ];
  };
})
