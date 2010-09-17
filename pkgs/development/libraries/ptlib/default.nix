x@{builderDefsPackage
  , autoconf, automake, libtool, doxygen, pkgconfig, bison, flex, unixODBC
  , openssl, openldap, cyrus_sasl, krb5, expat, SDL, libdv, libv4l, alsaLib
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="ptlib";
    baseVersion="2.6";
    patchlevel="7";
    version="${baseVersion}.${patchlevel}";
    name="${baseName}-${version}";
    url="mirror://gnome/sources/${baseName}/${baseVersion}/${name}.tar.bz2";
    hash="0zxrygl2ivbciqf97yd9n67ch9vd9gp236w96i6ia8fxzqjq5lkx";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Portable Tools from OPAL VoIP";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/sources/ptlib/";
    };
  };
}) x

