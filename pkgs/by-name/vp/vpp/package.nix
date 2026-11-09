{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
  writeText,

  cmake,
  pkg-config,
  python3,

  # optional dependencies
  withStackTraces ? true,
  libiberty,
  libunwind,

  withOpenssl ? true, # tls/quic/wireguard plugins
  openssl,

  withLibPcap ? true, # bpf_trace_filter plugin
  libpcap,

  withNetlinkLibs ? true, # linux-cp plugin
  libnl,
  libmnl,

  withRdma ? true,
  rdma-core,

  withDpdk ? true,
  dpdk,
  jansson,

  withAfXdp ? true,
  xdp-tools,
  libbpf,
  # Support for all network cards, but slower than native XDP
  enableAfXdpSkbMode ? false,

  libelf,
  zlib,
}:
let
  dpdk' = dpdk.overrideAttrs (old: {
    mesonFlags = old.mesonFlags ++ [ "-Denable_driver_sdk=true" ];
  });

  # >=25.02 uses /etc/os-release, so we substitute it
  osRelease = writeText "os-release" "ID=nixos";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vpp";
  version = "26.02";

  src = fetchFromGitHub {
    owner = "FDio";
    repo = "vpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z9yh1ZMP28SSzHNBdO7UnvVqsIqtXUcwYZUH1UdBUB0=";
  };

  postPatch = ''
    patchShebangs scripts/
    substituteInPlace pkg/CMakeLists.txt \
      --replace-fail "/etc/os-release" "${osRelease}"
    substituteInPlace plugins/dpdk/device/common.c \
      --replace-fail "RTE_DEV_TO_PCI (info->device)" "RTE_BUS_DEVICE (info->device, struct rte_pci_device)"
  '';

  preConfigure = ''
    echo "${finalAttrs.version}-nixos" > scripts/.version
    ./scripts/version
  '';

  postConfigure = ''
    patchShebangs ../tools/
    patchShebangs ../vpp-api/
  '';

  sourceRoot = "${finalAttrs.src.name}/src";

  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers -Wno-error=maybe-uninitialized";

  cmakeFlags = [
    "-DVPP_PLATFORM=default"
    "-DVPP_LIBRARY_DIR=lib"
    "-DVPP_BUILD_PYTHON_API=false" # fails to build as of 25.10
  ]
  ++ lib.optional withDpdk "-DVPP_USE_SYSTEM_DPDK=ON";

  nativeBuildInputs = [
    cmake
    pkg-config
    (python3.withPackages (ps: [ ps.ply ]))
  ];

  buildInputs =
    lib.optionals withStackTraces [
      libiberty
      libunwind
    ]
    ++ lib.optional withOpenssl openssl
    ++ lib.optional withLibPcap libpcap
    ++ lib.optionals withNetlinkLibs [
      libnl
      libmnl
    ]
    ++ lib.optionals withDpdk [
      dpdk'
      jansson
      libelf
      zlib
    ]
    ++ lib.optional withRdma rdma-core
    ++ lib.optionals withAfXdp [
      libelf
      libbpf
      xdp-tools
      zlib
    ];

  strictDeps = true;

  patches = [
    # VPP links to static RDMA/XDP by default
    ./use-dynamic-libs.patch
    (fetchpatch2 {
      name = "tap-include-limits.h.patch";
      url = "https://github.com/FDio/vpp/commit/70a225d6b28222b03b8d46cf3f52512516ae6786.patch?full_index=1";
      relative = "src";
      hash = "sha256-KQDhvuJxGuovn9kgjOOR3wLmntOqkVkRjAejSBF5gGE=";
    })
  ]
  ++ lib.optional enableAfXdpSkbMode ./xdp-skb-mode.patch;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, scalable layer 2-4 multi-platform network stack running in user space";
    homepage = "https://s3-docs.fd.io/vpp/${finalAttrs.version}/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "vpp";
    maintainers = with lib.maintainers; [ maevii ];
  };
})
