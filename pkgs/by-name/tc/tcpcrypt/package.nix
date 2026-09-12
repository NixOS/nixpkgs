{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  libcap,
  libpcap,
  libnfnetlink,
  libnetfilter_conntrack,
  libnetfilter_queue,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcpcrypt";
  version = "0.5";

  src = fetchFromGitHub {
    repo = "tcpcrypt";
    owner = "scslab";
    rev = "v${finalAttrs.version}";
    sha256 = "0a015rlyvagz714pgwr85f8gjq1fkc0il7d7l39qcgxrsp15b96w";
  };

  postUnpack = "mkdir -vp $sourceRoot/m4";

  outputs = [
    "bin"
    "dev"
    "out"
  ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    libpcap
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    libnfnetlink
    libnetfilter_conntrack
    libnetfilter_queue
  ];

  # https://github.com/sorbo/tcpcrypt/blob/b2673e88570d3370e6b37698f58d5ee9bb116d8d/user/src/checksum.c#L64
  #
  # in_cksum() casts a `struct tcp_ph` through `unsigned short *`, so with
  # strict aliasing and optimization enabled, GCC breaks the program.
  env.CFLAGS = "-O2 -fno-strict-aliasing";

  enableParallelBuilding = true;

  passthru.tests.nixos = nixosTests.tcpcrypt;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "http://tcpcrypt.org/";
    description = "Fast TCP encryption";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
  };
})
