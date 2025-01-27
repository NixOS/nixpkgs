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
  version = "0.14.1";

  src = fetchgit {
    url = "https://git.taler.net/sync.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v+BBn9GZ+4Zc8iUebGmLtxAQN+7+cTdG8jNOpi+jN2c=";
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
    platforms = lib.platforms.linux;
  };
})
