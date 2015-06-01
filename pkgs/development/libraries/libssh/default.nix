{ stdenv, fetchurl, pkgconfig, cmake

# Optional Dependencies
, libheimdal ? null, zlib ? null, libsodium ? null

# Crypto Dependencies
, openssl ? null, libgcrypt ? null
}:

with stdenv;
let
  # Prefer openssl
  cryptoStr = if shouldUsePkg openssl != null then "openssl"
    else if shouldUsePkg libgcrypt != null then "libgcrypt"
      else "none";
  crypto = {
    openssl = openssl;
    libgcrypt = libgcrypt;
    none = null;
  }.${cryptoStr};

  optLibheimdal = shouldUsePkg libheimdal;
  optZlib = shouldUsePkg zlib;
  optLibsodium = shouldUsePkg libsodium;
in

assert crypto != null;

stdenv.mkDerivation rec {
  name = "libssh-0.7.0";

  src = fetchurl {
    url = "https://git.libssh.org/projects/libssh.git/snapshot/libssh-0.7.0.tar.gz";
    sha256 = "1wfrdqhv97f4ycd9bcpgb6gw47kr7b2iq8cz5knk8a6n9c6870k0";
  };

  patches = [ ./0001-Reintroduce-ssh_forward_listen-Fixes-194.patch ];

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  cmakeFlags = [
    "-DWITH_GSSAPI=${if optLibheimdal != null then "ON" else "OFF"}"
    "-DWITH_ZLIB=${if optZlib != null then "ON" else "OFF"}"
    "-DWITH_SSH1=OFF"
    "-DWITH_SFTP=ON"
    "-DWITH_SERVER=ON"
    "-DWITH_STATIC_LIB=OFF"
    "-DWITH_DEBUG_CRYPTO=OFF"
    "-DWITH_DEBUG_CALLTRACE=OFF"
    "-DWITH_GCRYPT=${if cryptoStr == "libgcrypt" then "ON" else "OFF"}"
    "-DWITH_PCAP=ON"
    "-DWITH_INTERNAL_DOC=OFF"
    "-DWITH_TESTING=OFF"
    "-DWITH_CLIENT_TESTING=OFF"
    "-DWITH_BENCHMARKS=OFF"
    "-DWITH_EXAMPLES=OFF"
    "-DWITH_NACL=${if optLibsodium != null then "ON" else "OFF"}"
  ] ++ stdenv.lib.optionals (optLibsodium != null) [
    "-DNACL_LIBRARY=${optLibsodium}/lib/libsodium.so"
    "-DNACL_INCLUDE_DIR=${optLibsodium}/include"
  ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ optLibheimdal optZlib optLibsodium crypto ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander urkud wkennington ];
    platforms = platforms.all;
  };
}
