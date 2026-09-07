{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  glib,
  libnotify,
  gtk3,
  libgee,
  keybinder3,
  json-glib,
  zeitgeist,
  vala,
  gobject-introspection,
}:

let
  version = "0.2.99.4";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "synapse";
  inherit version;

  src = fetchurl {
    url = "https://launchpad.net/synapse-project/0.3/${finalAttrs.version}/+download/synapse-${finalAttrs.version}.tar.xz";
    sha256 = "1g6x9knb4jy1d8zgssjhzkgac583137pibisy9whjs8mckaj4k1j";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    vala
    # For setup hook
    gobject-introspection
  ];
  buildInputs = [
    glib
    libnotify
    gtk3
    libgee
    keybinder3
    json-glib
    zeitgeist
  ];

  meta = {
    longDescription = ''
      Semantic launcher written in Vala that you can use to start applications
      as well as find and access relevant documents and files by making use of
      the Zeitgeist engine
    '';
    description = "Semantic launcher to start applications and find relevant files";
    homepage = "https://launchpad.net/synapse-project";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mahe ];
    platforms = with lib.platforms; all;
    mainProgram = "synapse";
  };
})
