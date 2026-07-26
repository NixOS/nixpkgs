{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  libstrophe,
  glib,
  gpgme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmppc";
  version = "0.1.2";

  src = fetchFromCodeberg {
    owner = "Anoxinon_e.V.";
    repo = "xmppc";
    rev = finalAttrs.version;
    sha256 = "07cy3j4g7vycagdiva3dqb59361lw7s5f2yydpczmyih29v7hkm8";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libstrophe
    glib
    gpgme
  ];

  preAutoreconf = ''
    mkdir m4
  '';

  meta = {
    description = "Command Line Interface Tool for XMPP";
    mainProgram = "xmppc";
    homepage = "https://codeberg.org/Anoxinon_e.V./xmppc";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jugendhacker ];
  };
})
