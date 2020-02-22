{ stdenv, fetchFromGitHub, autoreconfHook, doxygen
, numactl, rdma-core, libbfd, libiberty, perl, zlib
}:

let
  version = "1.7.0";

in stdenv.mkDerivation {
  name = "ucx-${version}";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "149p8s7jrg7pbbq0hw0qm8va119bsl19q4scgk94vjqliyc1s33h";
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

  meta = with stdenv.lib; {
    description = "Unified Communication X library";
    homepage = http://www.openucx.org;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
