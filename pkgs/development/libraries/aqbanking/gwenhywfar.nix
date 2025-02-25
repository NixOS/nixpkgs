{
  lib,
  stdenv,
  fetchurl,
  gnutls,
  openssl,
  libgcrypt,
  libgpg-error,
  pkg-config,
  gettext,
  which,

  # GUI support
  gtk3,
  qt5,

  pluginSearchPaths ? [
    "/run/current-system/sw/lib/gwenhywfar/plugins"
    ".nix-profile/lib/gwenhywfar/plugins"
  ],
}:

let
  inherit ((import ./sources.nix).gwenhywfar) hash releaseId version;
in
stdenv.mkDerivation rec {
  pname = "gwenhywfar";
  inherit version;

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/${pname}-${version}.tar.gz";
    inherit hash;
  };

  configureFlags = [
    "--with-openssl-includes=${openssl.dev}/include"
    "--with-openssl-libs=${lib.getLib openssl}/lib"
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-guis=gtk3 qt5")
  '';

  postPatch =
    let
      isRelative = path: builtins.substring 0 1 path != "/";
      mkSearchPath =
        path:
        ''
          p; g; s,\<PLUGINDIR\>,"${path}",g;
        ''
        + lib.optionalString (isRelative path) ''
          s/AddPath(\(.*\));/AddRelPath(\1, GWEN_PathManager_RelModeHome);/g
        '';

    in
    ''
      sed -i -e '/GWEN_PathManager_DefinePath.*GWEN_PM_PLUGINDIR/,/^#endif/ {
        /^#if/,/^#endif/ {
          H; /^#endif/ {
            ${lib.concatMapStrings mkSearchPath pluginSearchPaths}
          }
        }
      }' src/gwenhywfar.c

      # Strip off the effective SO version from the path so that for example
      # "lib/gwenhywfar/plugins/60" becomes just "lib/gwenhywfar/plugins".
      sed -i -e '/^gwenhywfar_plugindir=/s,/\''${GWENHYWFAR_SO_EFFECTIVE},,' \
        configure
    '';

  nativeBuildInputs = [
    pkg-config
    gettext
    which
  ];

  buildInputs = [
    gtk3
    qt5.qtbase
    gnutls
    openssl
    libgcrypt
    libgpg-error
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = "https://www.aquamaniac.de/rdm/projects/gwenhywfar";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
