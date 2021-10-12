{ lib, stdenv, fetchFromGitHub, autoreconfHook, doxygen
, numactl, rdma-core, libbfd, libiberty, perl, zlib
}:

stdenv.mkDerivation rec {
  pname = "ucx";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "0a4rbgr3hn3h42krb7lasfidhqcavacbpp1pv66l4lvfc0gkwi2i";
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
