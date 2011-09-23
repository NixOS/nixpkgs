x@{builderDefsPackage
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="libmodplug";
    version="0.8.8.4";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/modplug-xmms/${baseName}/${version}/${name}.tar.gz";
    hash="1xv44bd84c4qi41i1wwjr6qzazx15l85yvi74sz49ldyvlyy2pjw";
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
    description = "Music library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.publicDomain;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/modplug-xmms/files/libmodplug/";
    };
  };
}) x

