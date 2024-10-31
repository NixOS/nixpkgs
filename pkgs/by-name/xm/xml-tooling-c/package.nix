{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  boost,
  curl,
  openssl,
  log4shib,
  xercesc,
  xml-security-c,
}:

stdenv.mkDerivation rec {
  pname = "xml-tooling-c";
  version = "3.2.4";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xmltooling.git";
    rev = version;
    hash = "sha256-FQ109ahOSWj3hvaxu1r/0FTpCuWaLgSEKM8NBio+wqU=";
  };

  buildInputs = [
    boost
    curl
    openssl
    log4shib
    xercesc
    xml-security-c
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-std=c++14";

  enableParallelBuilding = true;

  meta = {
    description = "Low-level library that provides a high level interface to XML processing for OpenSAML 2";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sigmanificient ];
  };
}
