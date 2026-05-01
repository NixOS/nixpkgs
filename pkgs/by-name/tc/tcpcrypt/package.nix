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

  enableParallelBuilding = true;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "http://tcpcrypt.org/";
    description = "Fast TCP encryption";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
  };
})
