{ lib, stdenv, fetchFromGitHub, autoreconfHook, doxygen
, numactl, rdma-core, libbfd, libiberty, perl, zlib
}:

stdenv.mkDerivation rec {
  pname = "ucx";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "1j2gfw4anixb5ajgiyn7bcca8pgjvsaf0y0b2xz88s9hdx0h6gs9";
  };

  nativeBuildInputs = [ autoreconfHook doxygen ];

  buildInputs = [ numactl rdma-core libbfd libiberty perl zlib ];

  configureFlags = [
    "--with-rdmacm=${rdma-core}"
    "--with-dc"
    "--with-rc"
    "--with-dm"
    "--with-verbs=${rdma-core}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Unified Communication X library";
    homepage = "http://www.openucx.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
