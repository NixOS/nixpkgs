{
  autoreconfHook,
  curl,
  fetchgit,
  gnunet,
  jansson,
  lib,
  libgcrypt,
  libmicrohttpd,
  libnfc,
  libsodium,
  pkg-config,
  stdenv,
  taler-exchange,
  taler-merchant,
  qrencode,
}:

let
  docs = fetchgit {
    url = "https://git.taler.net/taler-docs.git";
    rev = "b97d82f99dc32b0fdb7942dbb501603a2c86f8b1";
    hash = "sha256-qyp/iHHGxE0A2UCSY+muyzUd0upuJeQK1OIaacsmrjs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taler-mdb";
  version = "0.14.1";

  src = fetchgit {
    url = "https://git.taler.net/taler-mdb.git";
    tag = "v${finalAttrs.version}";
    # fatal: repository 'https://git.taler.net/docs.git/' not found
    fetchSubmodules = false;
    hash = "sha256-+raX3O2RNaMsN7Wi6F0P/lccpLOtL13EU4Fpe9lCueA=";
  };

  postPatch = ''
    cp -R ${docs}/* doc/prebuilt/
  '';

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
    libnfc
    libsodium
    qrencode
    taler-exchange
    taler-merchant
  ];

  doInstallCheck = true;

  meta = {
    homepage = "https://git.taler.net/taler-mdb.git";
    description = "Sales integration with the Multi-Drop-Bus of Snack machines, NFC readers and QR code display";
    license = lib.licenses.agpl3Plus;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ];
  };
})
