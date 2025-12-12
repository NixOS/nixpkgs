{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  libgcrypt,
  pkg-config,
  curlWithGnuTls,
  gnunet,
  jansson,
  libmicrohttpd,
  libpq,
  libsodium,
  libtool,
  taler-exchange,
  taler-merchant,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taler-sync";
  version = "1.0.0";

  src = fetchgit {
    url = "https://git.taler.net/sync.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-di+AgCCgOTvzR6Fberz1ISo6ZT+OsKikeNCU2HZHSz4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt
    pkg-config
  ];

  buildInputs = [
    curlWithGnuTls
    gnunet
    jansson
    libgcrypt
    libmicrohttpd
    libpq
    libsodium
    libtool
    taler-exchange
    taler-merchant
  ];

  preFixup = ''
    substituteInPlace "$out/bin/sync-dbconfig" \
      --replace-fail "/bin/bash" "${runtimeShell}"
  '';

  meta = {
    description = "Backup and synchronization service";
    homepage = "https://git.taler.net/sync.git";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.linux;
  };
})
