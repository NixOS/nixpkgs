{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  CoreServices,
  curlHTTP3,
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kJt4aQGNiJ0XhlEKunR8jYKytv3rh23jRrNelCDe/Kk=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_STATIC_LIB" false)
  ];

  doCheck = true;

  passthru.tests = {
    inherit curlHTTP3;
  };

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
