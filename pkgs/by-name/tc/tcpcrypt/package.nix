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
    hash = "sha256-3KRVwtW5P4bToKcdGgGbLmD5kCso83dJOP+p7WkuASg=";
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
    homepage = "https://github.com/scslab/tcpcrypt";
    description = "Fast TCP encryption";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
  };
})
