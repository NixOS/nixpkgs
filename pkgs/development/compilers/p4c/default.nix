{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, boehmgc
, bison
, flex
, protobuf
, gmp
, boost
, python3
, doxygen
, graphviz
, libbpf
, libllvm
, enableDocumentation ? true
, enableBPF ? true
, enableDPDK ? true
, enableBMV2 ? true
, enableGraphBackend ? true
, enableP4Tests ? true
, enableGTests ? true
, enableMultithreading ? false
}:
let
  toCMakeBoolean = v: if v then "ON" else "OFF";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "p4c";
  version = "1.2.4.1";

  src = fetchFromGitHub {
    owner = "p4lang";
    repo = "p4c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Whdryz1Gt0ymE7cj+mI95lW3Io9yBvLqcWa04gu5zEw=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix gcc-13 build:
    #   https://github.com/p4lang/p4c/pull/4084
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/p4lang/p4c/commit/6756816100b7c51e3bf717ec55114a8e8575ba1d.patch";
      hash = "sha256-wWM1qjgQCNMPdrhQF38jzFgODUsAcaHTajdbV7L3y8o=";
    })
  ];

  postFetch = ''
    rm -rf backends/ebpf/runtime/contrib/libbpf
    rm -rf control-plane/p4runtime
  '';

  cmakeFlags = [
    "-DENABLE_BMV2=${toCMakeBoolean enableBMV2}"
    "-DENABLE_EBPF=${toCMakeBoolean enableBPF}"
    "-DENABLE_UBPF=${toCMakeBoolean enableBPF}"
    "-DENABLE_DPDK=${toCMakeBoolean enableDPDK}"
    "-DENABLE_P4C_GRAPHS=${toCMakeBoolean enableGraphBackend}"
    "-DENABLE_P4TEST=${toCMakeBoolean enableP4Tests}"
    "-DENABLE_DOCS=${toCMakeBoolean enableDocumentation}"
    "-DENABLE_GC=ON"
    "-DENABLE_GTESTS=${toCMakeBoolean enableGTests}"
    "-DENABLE_PROTOBUF_STATIC=OFF"  # static protobuf has been removed since 3.21.6
    "-DENABLE_MULTITHREAD=${toCMakeBoolean enableMultithreading}"
    "-DENABLE_GMP=ON"
  ];

  checkTarget = "check";

  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    cmake
  ]
  ++ lib.optionals enableDocumentation [ doxygen graphviz ]
  ++ lib.optionals enableBPF [ libllvm libbpf ];

  buildInputs = [
    protobuf
    boost
    boehmgc
    gmp
    flex
    python3
  ];

  meta = {
    changelog = "https://github.com/p4lang/p4c/releases";
    description = "Reference compiler for the P4 programming language";
    homepage = "https://github.com/p4lang/p4c";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raitobezarius govanify ];
    platforms = lib.platforms.linux;
  };
})
