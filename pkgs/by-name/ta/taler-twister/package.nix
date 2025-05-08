{
  autoreconfHook,
  curl,
  fetchgit,
  gnunet,
  jansson,
  lib,
  libgcrypt,
  libmicrohttpd,
  libsodium,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taler-twister";
  version = "0.14.0";

  src = fetchgit {
    url = "https://git.taler.net/twister.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NyNULsvGEIa+cWX0WwegV9AjZj9HJkLHJrk2wOdORKs=";
  };

  # Patch code to use libmicrohttpd instead of gnunet-json
  # This is a temporary workaround until the upstream code is fixed
  postPatch = ''
    substituteInPlace src/twister/taler-twister-service.c \
      --replace-fail "gnunet_json" "gnunet_mhd" \
      --replace-fail "GNUNET_JSON" "GNUNET_MHD"
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
  };
})
