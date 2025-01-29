{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  check,
  openssl,
  python3,
  subunit,
  mbedtls_2,
  libpcap,
  libnl,
  libmnl,
  libelf,
  dpdk,
  jansson,
  zlib,
  rdma-core,
  libbpf,
  xdp-tools,
  enableDpdk ? true,
  enableRdma ? true,
  # FIXME: broken: af_xdp plugins - no working libbpf found - af_xdp plugin disabled
  enableAfXdp ? false,
}:

let
  dpdk' = dpdk.overrideAttrs (old: {
    mesonFlags = old.mesonFlags ++ [ "-Denable_driver_sdk=true" ];
  });

  rdma-core' = rdma-core.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DENABLE_STATIC=1"
      "-DBUILD_SHARED_LIBS:BOOL=false"
    ];
  });

  xdp-tools' = xdp-tools.overrideAttrs (old: {
    postInstall = "";
    dontDisableStatic = true;
  });
in
stdenv.mkDerivation rec {
  pname = "vpp";
  version = "24.10";

  src = fetchFromGitHub {
    owner = "FDio";
    repo = "vpp";
    rev = "v${version}";
    hash = "sha256-GcmblIAu/BDbqZRycmnBsHkvzJe07qB2lSfDnO7ZYtg=";
  };

  postPatch = ''
    patchShebangs scripts/
    substituteInPlace CMakeLists.txt \
      --replace "plugins tools/vppapigen tools/g2 tools/perftool cmake pkg" \
      "plugins tools/vppapigen tools/g2 tools/perftool cmake"
  '';

  preConfigure = ''
    echo "${version}-nixos" > scripts/.version
    scripts/version
  '';

  postConfigure = ''
    patchShebangs ../tools/
    patchShebangs ../vpp-api/
  '';

  sourceRoot = "source/src";

  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = "-Wno-error -Wno-array-bounds -Wno-maybe-uninitialized";

  cmakeFlags = [
    "-DVPP_PLATFORM=default"
    "-DVPP_LIBRARY_DIR=lib"
  ] ++ lib.optional enableDpdk "-DVPP_USE_SYSTEM_DPDK=ON";

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional enableDpdk dpdk' ++ lib.optional enableRdma rdma-core'.dev;

  buildInputs =
    [
      check
      openssl
      (python3.withPackages (ps: [ ps.ply ]))

      subunit # vapi tests
      mbedtls_2 # tlsmbed plugin
      libpcap # bpf_trace_filter plugin

      # linux-cp plugin
      libnl
      libmnl
    ]
    ++ lib.optionals enableDpdk [
      # dpdk plugin
      libelf
      jansson
      zlib
    ]
    ++ lib.optionals enableAfXdp [
      # af_xdp plugin
      libelf
      libbpf
      xdp-tools'
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, scalable layer 2-4 multi-platform network stack running in user space";
    homepage = "https://s3-docs.fd.io/vpp/${version}/";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ romner-set ];
    mainProgram = "vpp";
    platforms = lib.platforms.linux;
  };
}
