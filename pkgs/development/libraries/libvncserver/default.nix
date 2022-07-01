{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, libjpeg
, openssl
, zlib
, libgcrypt
, libpng
, systemd
, Carbon
}:

stdenv.mkDerivation rec {
  pname = "libvncserver";
  version = "0.9.13";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    rev = "LibVNCServer-${version}";
    sha256 = "sha256-gQT/M2u4nWQ0MfO2gWAqY0ZJc7V9eGczGzcsxKmG4H8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libjpeg
    openssl
    libgcrypt
    libpng
  ] ++ lib.optionals stdenv.isLinux [
    systemd
  ] ++ lib.optional stdenv.isDarwin [
    Carbon
  ];

  propagatedBuildInputs = [
    zlib
  ];

  meta = with lib; {
    description = "VNC server library";
    homepage = "https://libvnc.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
