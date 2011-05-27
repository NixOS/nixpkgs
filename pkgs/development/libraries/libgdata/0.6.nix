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
    majorVersion="0.6";
    minorVersion="6";
    version="${majorVersion}.${minorVersion}";
    name="${baseName}-${version}";
    url="mirror://gnome/sources/${baseName}/${majorVersion}/${name}.tar.bz2";
    hash="cf6de3b60443faaf8e9c3b4c4b160c22a48df7925c1c793a7bb71d3d746f69f5";
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
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/${sourceInfo.baseName}/${sourceInfo.majorVersion}";
    };
  };
}) x

