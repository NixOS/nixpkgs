{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  bison,
  libevent,
  libgrapheme,
  libressl,
  ncurses,
  autoreconfHook,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "telescope";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = "telescope";
    tag = finalAttrs.version;
    hash = "sha256-GKeUXa4RKYkoywrCrpenfLt10Rdj9L0xYI3tf2hFAbk=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r libgrapheme
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
  ];

  buildInputs = [
    libevent
    libgrapheme
    libressl
    ncurses
  ];

  configureFlags = [
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "w3m-like browser for Gemini";
    homepage = "https://telescope-browser.org/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ heph2 ];
    platforms = lib.platforms.unix;
  };
})
