{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, libqb, libxml2, libnl, lksctp-tools
, nss, openssl, bzip2, lzo, lz4, xz, zlib, zstd
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "kronosnet";
  version = "1.23";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+uQXV5tOLsBPFzfFHqwV1Oz4+KwZMkdjO8zfIljV+ro=";
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
