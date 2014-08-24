x@{builderDefsPackage
  , unzip
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="angelscript";
    version = "2.29.1";
    name="${baseName}-${version}";
    url="http://www.angelcode.com/angelscript/sdk/files/angelscript_${version}.zip";
    sha256 = "081a0wnn1hl0hjgrg0nz63ff7k7dgrwsgszka5i7623ny407fkl5";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["prepareBuild" "doMake" "cleanLib" "doMakeInstall" "installDocs"];

  prepareBuild = a.fullDepEntry ''
    cd angelscript/projects/gnuc
    sed -i makefile -e "s@LOCAL [?]= .*@LOCAL = $out@"
    mkdir -p "$out/lib" "$out/bin" "$out/share" "$out/include"
    export SHARED=1 
    export VERSION="${version}"
  '' ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  cleanLib = a.fullDepEntry ''
    rm ../../lib/*
  '' ["minInit"];

  installDocs = a.fullDepEntry ''
    mkdir -p "$out/share/angelscript"
    cp -r ../../../docs  "$out/share/angelscript"
  '' ["defEnsureDir" "prepareBuild"];
      
  meta = {
    description = "Light-weight scripting library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.zlib;
    homepage="http://www.angelcode.com/angelscript/";
    downloadPage = "http://www.angelcode.com/angelscript/downloads.html";
    inherit version;
  };
}) x

