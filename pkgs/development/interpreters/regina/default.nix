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
    version="3.5";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${pname}/${pname}/${version}/${name}.tar.gz";
    hash="0gh0k6lbhfixs44adha7lxirl3a08jabdylzr6m7mh5q5fhzv5f8";
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
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/regina-rexx/files/regina-rexx/";
    };
  };
}) x

