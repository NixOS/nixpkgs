{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  curl,
  gnunet,
  jansson,
  libgcrypt,
  libmicrohttpd,
  libsodium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taler-twister";
  version = "1.0.0";

  src = fetchgit {
    url = "https://git.taler.net/twister.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ir+kU9bCWwhqR88hmNHB5cm1DXOQowI5y6GdhWpX/L0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    gnunet
    jansson
    libgcrypt
    libmicrohttpd
    libsodium
  ];

  doInstallCheck = true;

  meta = {
    homepage = "https://git.taler.net/twister.git";
    description = "Fault injector for HTTP traffic";
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "twister";
    platforms = lib.platforms.linux;
  };
})
