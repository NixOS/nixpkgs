{ lib
, stdenv
, fetchFromGitHub
, zlib
, openssl
, cmake
, SystemConfiguration
}:

stdenv.mkDerivation rec {
  version = "3.6.0";
  pname = "libre";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "re";
    rev = "v${version}";
    sha256 = "sha256-pFtrmrNRSL1lw10LjayOoNFrW/tTPXwmUipwC5v1MZs=";
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
    description = "A library for real-time communications with async IO support and a complete SIP stack";
    homepage = "https://github.com/baresip/re";
    maintainers = with lib.maintainers; [ elohmeier raskin ];
    license = lib.licenses.bsd3;
  };
}
