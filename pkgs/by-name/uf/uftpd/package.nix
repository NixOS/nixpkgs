{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libuev,
  libite,
}:

stdenv.mkDerivation rec {
  pname = "uftpd";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "uftpd";
    rev = "v${version}";
    hash = "sha256-+y1eRPUgYf5laRFIDD1XOEfonPP8QMJNCSkmHlXIjdY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    libuev
    libite
  ];

  meta = with lib; {
    description = "FTP/TFTP server for Linux that just works™";
    homepage = "https://troglobit.com/projects/uftpd/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vifino ];
  };
}
