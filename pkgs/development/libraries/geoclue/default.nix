x@{builderDefsPackage
  , dbus, dbus_glib, glib, pkgconfig, libxml2, gnome, libxslt
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["gnome"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames))
    ++ [gnome.GConf];
  sourceInfo = rec {
    baseName="geoclue";
    version="0.12.0";
    name="${baseName}-${version}";
    url="http://folks.o-hand.com/jku/geoclue-releases/${name}.tar.gz";
    hash="15j619kvmdgj2hpma92mkxbzjvgn8147a7500zl3bap9g8bkylqg";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  propagatedBuildInputs = [a.dbus a.glib a.dbus_glib];

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixConfigure" "doConfigure" "doMakeInstall"];
      
  fixConfigure = a.fullDepEntry ''
    sed -e 's@-Werror@@' -i configure
  '' ["minInit" "doUnpack"];

  meta = {
    description = "Geolocation framework and some data providers";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://folks.o-hand.com/jku/geoclue-releases/";
    };
  };
}) x

