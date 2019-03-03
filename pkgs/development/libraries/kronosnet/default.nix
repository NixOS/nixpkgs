{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, libqb, libxml2, libnl, lksctp-tools
, nss, openssl, bzip2, lzo, lz4, xz, zlib
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "kronosnet";
  version = "1.7";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1vfwwv8i1n2yvlyx14sgyr2q5igf68qlsdhb1yisnw4bjs1g1s4x";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig doxygen ];

  buildInputs = [
    libqb libxml2 libnl lksctp-tools
    nss openssl
    bzip2 lzo lz4 xz zlib
  ];

  meta = with stdenv.lib; {
    description = "VPN on steroids";
    homepage = https://kronosnet.org/;
    license = [ licenses.lgpl21Plus licenses.gpl2Plus ];
  };
}
