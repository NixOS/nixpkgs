{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, libqb, libxml2, libnl, lksctp-tools
, nss, openssl, bzip2, lzo, lz4, xz, zlib, zstd
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "kronosnet";
  version = "1.21";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "14i4fl3g60gn5ay3dbwjcay3dnmnqr16zcp3g0wv9a3hjwh1if28";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config doxygen ];

  buildInputs = [
    libqb libxml2 libnl lksctp-tools
    nss openssl
    bzip2 lzo lz4 xz zlib zstd
  ];

  meta = with lib; {
    description = "VPN on steroids";
    homepage = "https://kronosnet.org/";
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    maintainers = with maintainers; [ ryantm ];
  };
}
