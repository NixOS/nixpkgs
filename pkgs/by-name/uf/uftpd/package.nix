{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libuev,
  libite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uftpd";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "uftpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cTWE4+lao+GF1X2raT9wxBMAcJPfGy75SPQDMu34QGw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    libuev
    libite
  ];

  meta = {
    description = "FTP/TFTP server for Linux that just works";
    homepage = "https://troglobit.com/projects/uftpd/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vifino ];
  };
})
