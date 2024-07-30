{ lib
, stdenv
, fetchFromGitHub
, zlib
, openssl
, cmake
, SystemConfiguration
}:

stdenv.mkDerivation rec {
  version = "3.14.0";
  pname = "libre";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "re";
    rev = "v${version}";
    sha256 = "sha256-g3SnLI4jbXfBOb9HcPWT9E+wN2x7KJ6Y2eF0YuJ43zU=";
  };

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    SystemConfiguration
  ];

  nativeBuildInputs = [ cmake ];
  makeFlags = [ "USE_ZLIB=1" "USE_OPENSSL=1" "PREFIX=$(out)" ]
    ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
    ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}"
  ;
  enableParallelBuilding = true;
  meta = {
    description = "Library for real-time communications with async IO support and a complete SIP stack";
    homepage = "https://github.com/baresip/re";
    maintainers = with lib.maintainers; [ raskin ];
    license = lib.licenses.bsd3;
  };
}
