{ lib, stdenv, fetchzip, fetchpatch, cmake
, libjpeg, openssl, zlib, libgcrypt, libpng
, systemd, Carbon
}:

let
  s = # Generated upstream information
  rec {
    pname = "libvncserver";
    version = "0.9.13";
    url = "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${version}.tar.gz";
    sha256 = "0zz0hslw8b1p3crnfy3xnmrljik359h83dpk64s697dqdcrzy141"; # unpacked archive checksum
  };
in
stdenv.mkDerivation {
  inherit (s) pname version;
  src = fetchzip {
    inherit (s) url sha256;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libjpeg openssl libgcrypt libpng ]
    ++ lib.optional stdenv.isLinux systemd
    ++ lib.optional stdenv.isDarwin Carbon;
  propagatedBuildInputs = [ zlib ];

  meta = {
    inherit (s) version;
    description = "VNC server library";
    homepage = "https://libvnc.github.io/";
    license = lib.licenses.gpl2Plus ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
