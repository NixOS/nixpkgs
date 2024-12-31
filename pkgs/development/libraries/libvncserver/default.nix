{ lib
, stdenv
, fetchFromGitHub
, cmake
, libjpeg
, openssl
, zlib
, libgcrypt
, libpng
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, Carbon
}:

stdenv.mkDerivation rec {
  pname = "libvncserver";
  version = "0.9.14";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    rev = "LibVNCServer-${version}";
    sha256 = "sha256-kqVZeCTp+Z6BtB6nzkwmtkJ4wtmjlSQBg05lD02cVvQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DWITH_SYSTEMD=${if withSystemd then "ON" else "OFF"}"
  ];

  buildInputs = [
    libjpeg
    openssl
    libgcrypt
    libpng
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ lib.optionals stdenv.isDarwin [
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
