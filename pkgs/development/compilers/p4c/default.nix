{ lib
, stdenv
, fetchFromGitHub
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
stdenv.mkDerivation rec {
  pname = "p4c";
  version = "1.2.4.0";

  src = fetchFromGitHub {
    owner = "p4lang";
    repo = "p4c";
    rev = "v${version}";
    sha256 = "sha256-nIPvB6nwa55dKNeoNRrjhnnmoYLYTviaoL79+hT6gGs=";
    fetchSubmodules = true;
  };

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

  meta = with lib; {
    homepage = "https://github.com/p4lang/p4c";
    changelog = "https://github.com/p4lang/p4c/releases";
    description = "Reference compiler for the P4 programming language";
    platforms = platforms.linux;
    maintainers = with maintainers; [ raitobezarius govanify ];
    license = licenses.asl20;
  };
}
