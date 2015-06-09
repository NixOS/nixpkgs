x@{builderDefsPackage
  , ncurses
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="Regina-REXX";
    pname="regina-rexx";
    version = "3.9.1";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${pname}/${pname}/${version}/${name}.tar.gz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "1vpksnjmg6y5zag9li6sxqxj2xapgalfz8krfxgg49vyk0kdy4sx";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];

  configureFlags = [
    "--libdir=$out/lib"
  ];
      
  meta = {
    description = "REXX interpreter";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl2;
    downloadPage = "http://sourceforge.net/projects/regina-rexx/files/regina-rexx/";
    inherit version;
  };
}) x

