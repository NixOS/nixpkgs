{ stdenv, fetchurl, libevent, buildEnv, autoreconfHook, numactl, libbfd, rdma-core, pkgconfig }:

let

  version = "1.7.0";

in stdenv.mkDerivation rec {
  pname = "ucx";
  inherit version;

  src = with stdenv.lib.versions; fetchurl {
    url = "https://github.com/openucx/ucx/archive/v${version}.tar.gz";
    sha256 = "11qinn1h8h9l9hwbxsvr6kvjpjsiz6xic0f95xj0dqchd51v5n6p";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = with stdenv; [ libbfd ]
    ++ lib.optionals isLinux [ numactl rdma-core ];

  configureFlags = with stdenv; [
    "--disable-fast-install"
    "--enable-compiler-opt=3"
    "--enable-mt"
  ] ++ lib.optionals isLinux [
    "--with-rdmacm=${rdma-core}"
    "--with-verbs=${rdma-core}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://openucx.readthedocs.io/en/master/;
    description = "Open source UCX implementation";
    maintainers = with maintainers; [ ikervagyok ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
