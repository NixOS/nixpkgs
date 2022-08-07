{ lib, stdenv, fetchFromGitHub, autoreconfHook, doxygen
, numactl, rdma-core, libbfd, libiberty, perl, zlib, symlinkJoin
, enableCuda ? false
, cudatoolkit
}:

let
  # Needed for configure to find all libraries
  cudatoolkit' = symlinkJoin {
    inherit (cudatoolkit) name meta;
    paths = [ cudatoolkit cudatoolkit.lib ];
  };

in stdenv.mkDerivation rec {
  pname = "ucx";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "sha256-DWiOmqxBAAH8DE7H0teoKyp+m3wYEo652ac7ey43Erg=";
  };

  nativeBuildInputs = [ autoreconfHook doxygen ];

  buildInputs = [
    libbfd
    libiberty
    numactl
    perl
    rdma-core
    zlib
  ] ++ lib.optional enableCuda cudatoolkit;

  configureFlags = [
    "--with-rdmacm=${rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${rdma-core}"
  ] ++ lib.optional enableCuda "--with-cuda=${cudatoolkit'}";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Unified Communication X library";
    homepage = "http://www.openucx.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
