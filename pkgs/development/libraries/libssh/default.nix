{ lib
, stdenv
, fetchurl
, pkg-config
, cmake
, zlib
, openssl
, libsodium

# for passthru.tests
, ffmpeg
, sshping
, wireshark
}:

stdenv.mkDerivation rec {
  pname = "libssh";
  version = "0.9.6";

  src = fetchurl {
    url = "https://www.libssh.org/files/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-hrz4hb2bgEZv4OBUU8WLh332GvqLqUeljDVtfw+rgps=";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  # single output, otherwise cmake and .pc files point to the wrong directory
  # outputs = [ "out" "dev" ];

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkg-config ];

  passthru.tests = {
    inherit ffmpeg sshping wireshark;
  };

  meta = with lib; {
    description = "SSH client library";
    homepage = "https://libssh.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
