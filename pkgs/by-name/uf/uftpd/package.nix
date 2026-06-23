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
  version = "2.16";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "uftpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fk/YwTqtFSnR6EeObAcZdUume2xK0wd6EOPSJpOwMTg=";
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
