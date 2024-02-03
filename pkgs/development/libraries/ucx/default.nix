{ lib, stdenv, fetchFromGitHub, autoreconfHook, doxygen, numactl
, rdma-core, libbfd, libiberty, perl, zlib, symlinkJoin, pkg-config
, config
, enableCuda ? config.cudaSupport
, cudatoolkit
, enableRocm ? false
, rocmPackages
}:

let
  # Needed for configure to find all libraries
  cudatoolkit' = symlinkJoin {
    inherit (cudatoolkit) name meta;
    paths = [ cudatoolkit cudatoolkit.lib ];
  };

  rocmList = with rocmPackages; [ rocm-core rocm-runtime rocm-device-libs clr ];

  rocm = symlinkJoin {
    name = "rocm";
    paths = rocmList;
  };

in
stdenv.mkDerivation rec {
  pname = "ucx";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "sha256-VxIxrk9qKM6Ncfczl4p2EhXiLNgPaYTmjhqi6/w2ZNY=";
  };

  outputs = [ "out" "doc" "dev" ];

  nativeBuildInputs = [ autoreconfHook doxygen pkg-config ];

  buildInputs = [
    libbfd
    libiberty
    numactl
    perl
    rdma-core
    zlib
  ] ++ lib.optional enableCuda cudatoolkit
  ++ lib.optionals enableRocm rocmList;

  configureFlags = [
    "--with-rdmacm=${lib.getDev rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${lib.getDev rdma-core}"
  ] ++ lib.optional enableCuda "--with-cuda=${cudatoolkit'}"
  ++ lib.optional enableRocm "--with-rocm=${rocm}";

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucx_info $dev

    moveToOutput share/ucx/examples $doc
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Unified Communication X library";
    homepage = "https://www.openucx.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
