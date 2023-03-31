{ lib, stdenv, fetchFromGitHub, autoreconfHook, doxygen, numactl
, rdma-core, libbfd, libiberty, perl, zlib, symlinkJoin, pkg-config
, config
, enableCuda ? config.cudaSupport or false
, cudatoolkit
, enableRocm ? false
, rocm-core, rocm-runtime, rocm-device-libs, hip
}:

let
  # Needed for configure to find all libraries
  cudatoolkit' = symlinkJoin {
    inherit (cudatoolkit) name meta;
    paths = [ cudatoolkit cudatoolkit.lib ];
  };
  rocm = symlinkJoin {
    name = "rocm";
    paths = [ rocm-core rocm-runtime rocm-device-libs hip ];
  };

in
stdenv.mkDerivation rec {
  pname = "ucx";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "sha256-oAigiCgbr27pX+kNl+RW1P10TKYFSKrHDK4U4z8WMko=";
  };

  nativeBuildInputs = [ autoreconfHook doxygen pkg-config ];

  buildInputs = [
    libbfd
    libiberty
    numactl
    perl
    rdma-core
    zlib
  ] ++ lib.optional enableCuda cudatoolkit
  ++ lib.optionals enableRocm [ rocm-core rocm-runtime rocm-device-libs hip ];

  configureFlags = [
    "--with-rdmacm=${rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${rdma-core}"
  ] ++ lib.optional enableCuda "--with-cuda=${cudatoolkit'}"
  ++ lib.optional enableRocm "--with-rocm=${rocm}";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Unified Communication X library";
    homepage = "https://www.openucx.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
