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
  version = "0.10.6";

  src = fetchurl {
    url = "https://www.libssh.org/files/${lib.versions.majorMinor version}/libssh-${version}.tar.xz";
    hash = "sha256-GGHUmPW28XQbarxz5ghHhJHtz5ydS2Yw7vbnRZbencE=";
  };

  # Do not split 'dev' output until lib/cmake/libssh/libssh-config.cmake
  # is fixed to point INTERFACE_INCLUDE_DIRECTORIES to .dev output.
  # Otherwise it breaks `plasma5Packages.kio-extras`:
  #   https://hydra.nixos.org/build/221540008/nixlog/3/tail
  #outputs = [ "out" "dev" ];

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  # Don’t build examples, which are not installed and require additional dependencies not
  # included in `buildInputs` such as libX11.
  cmakeFlags = [ "-DWITH_EXAMPLES=OFF" ];

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
