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

stdenv.mkDerivation rec {
  pname = "zmap";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dHJ3H3jc0/cVfJ7NVoJG+WF9+rowbgYF1Ph5/exxRkE=";
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

  meta = with lib; {
    homepage = "https://zmap.io/";
    license = licenses.asl20;
    description = "Fast single packet network scanner designed for Internet-wide network surveys";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
