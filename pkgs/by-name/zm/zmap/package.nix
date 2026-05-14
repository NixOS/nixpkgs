{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libjson,
  json_c,
  gengetopt,
  flex,
  byacc,
  gmp,
  libpcap,
  libunistring,
  judy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zmap";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zmap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fHCVo8OwQUzpdDq7dMBxvK15Ojth5UmNoPTVuTGUP58=";
  };

  cmakeFlags = [ "-DRESPECT_INSTALL_PREFIX_CONFIG=ON" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gengetopt
    flex
    byacc
  ];
  buildInputs = [
    libjson
    json_c
    gmp
    libpcap
    libunistring
    judy
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    homepage = "https://zmap.io/";
    license = lib.licenses.asl20;
    description = "Fast single packet network scanner designed for Internet-wide network surveys";
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
