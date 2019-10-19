{ stdenv, fetchurl, gnutls, openssl, libgcrypt, libgpgerror, pkgconfig, gettext
, which

# GUI support
, gtk2, gtk3, qt5

, pluginSearchPaths ? [
    "/run/current-system/sw/lib/gwenhywfar/plugins"
    ".nix-profile/lib/gwenhywfar/plugins"
  ]
}:

stdenv.mkDerivation rec {
  pname = "gwenhywfar";
  version = "5.2.0";

  src = fetchurl {
    url = https://www.aquamaniac.de/rdm/attachments/download/256/gwenhywfar-5.2.0.tar.gz;
    sha256 = "0ri79mfy9qr7phqbshdwanz345mk1lwl17fbrj3w7j1jma0iz3pd";
  };

  configureFlags = [
    "--with-openssl-includes=${openssl.dev}/include"
    "--with-openssl-libs=${openssl.out}/lib"
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-guis=gtk2 gtk3 qt5")
  '';

  postPatch = let
    isRelative = path: builtins.substring 0 1 path != "/";
    mkSearchPath = path: ''
      p; g; s,\<PLUGINDIR\>,"${path}",g;
    '' + stdenv.lib.optionalString (isRelative path) ''
      s/AddPath(\(.*\));/AddRelPath(\1, GWEN_PathManager_RelModeHome);/g
    '';

  in ''
    sed -i -e '/GWEN_PathManager_DefinePath.*GWEN_PM_PLUGINDIR/,/^#endif/ {
      /^#if/,/^#endif/ {
        H; /^#endif/ {
          ${stdenv.lib.concatMapStrings mkSearchPath pluginSearchPaths}
        }
      }
    }' src/gwenhywfar.c

    # Strip off the effective SO version from the path so that for example
    # "lib/gwenhywfar/plugins/60" becomes just "lib/gwenhywfar/plugins".
    sed -i -e '/^gwenhywfar_plugindir=/s,/\''${GWENHYWFAR_SO_EFFECTIVE},,' \
      configure
  '';

  nativeBuildInputs = [ pkgconfig gettext which ];

  buildInputs = [ gtk2 gtk3 qt5.qtbase gnutls openssl libgcrypt libgpgerror ];

  meta = with stdenv.lib; {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = http://www2.aquamaniac.de/sites/download/packages.php?package=01&showall=1;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
