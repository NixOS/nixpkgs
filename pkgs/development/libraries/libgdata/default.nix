x@{builderDefsPackage
  , glib, libsoup, libxml2, pkgconfig, intltool, perl
  , libtasn1, nettle, gmp
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="libgdata";
    majorVersion="0.8";
    minorVersion="1";
    version="${majorVersion}.${minorVersion}";
    name="${baseName}-${version}";
    url="mirror://gnome/sources/${baseName}/${majorVersion}/${name}.tar.bz2";
    hash="1ffhd1dvjflwjsiba1qdianlzfdlfkjgifmw3c7qs2g6fzkf62q8";
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
    description = "GData API library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl21Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/${sourceInfo.baseName}";
    };
  };
}) x

