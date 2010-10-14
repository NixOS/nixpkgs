x@{builderDefsPackage
  , libusb, libraw1394, dcraw, intltool, perl
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="libunicap";
    version="0.9.12";
    name="${baseName}-${version}";
    url="http://www.unicap-imaging.org/downloads/${name}.tar.gz";
    hash="05zcnnm4dfc6idihfi0fq5xka6x86zi89wip2ca19yz768sd33s9";
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
  phaseNames = ["fixIncludes" "fixMakefiles" "doConfigure" "doMakeInstall"];

  fixIncludes = a.fullDepEntry (''
    find . -type f -exec sed -e '/linux\/types\.h/d' -i '{}' ';'
  '') ["minInit" "doUnpack"];

  fixMakefiles = a.fullDepEntry (''
    sed -e 's@/etc/udev@'"$out"'/&@' -i data/Makefile.*
  '') ["minInit" "doUnpack"];

  meta = {
    description = "Universal video capture API";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://unicap-imaging.org/download.htm";
    };
  };
}) x

