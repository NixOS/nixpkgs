{ lib, stdenv, fetchFromGitHub, zlib, openssl }:
stdenv.mkDerivation rec {
  version = "2.7.0";
  pname = "libre";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "re";
    rev = "v${version}";
    sha256 = "sha256-YGd0ft61L5ZmcWY0+wON2YgX1fKAcQlIGHNaD7I7exg=";
  };
  buildInputs = [ zlib openssl ];
  makeFlags = [ "USE_ZLIB=1" "USE_OPENSSL=1" "PREFIX=$(out)" ]
    ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
    ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    description = "A library for real-time communications with async IO support and a complete SIP stack";
    homepage = "https://github.com/baresip/re";
    maintainers = with lib.maintainers; [ elohmeier raskin ];
    license = lib.licenses.bsd3;
  };
}
