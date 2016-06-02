{ stdenv, fetchurl, gnutls, gtk, libgcrypt, pkgconfig, gettext, qt4

, pluginSearchPaths ? [
    "/run/current-system/sw/lib/gwenhywfar/plugins"
    ".nix-profile/lib/gwenhywfar/plugins"
  ]
}:

stdenv.mkDerivation rec {
  name = "gwenhywfar-${version}";
  version = "4.15.3";

  src = let
    inherit ((import ./sources.nix).gwenhywfar) sha256 releaseId;
    qstring = "package=01&release=${releaseId}&file=01";
    mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  in fetchurl {
    name = "${name}.tar.gz";
    urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
    inherit sha256;
  };

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

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs = [ gtk qt4 gnutls libgcrypt ];

  QTDIR = qt4;

  meta = with stdenv.lib; {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = "http://www2.aquamaniac.de/sites/download/packages.php?package=01&showall=1";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
