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
    version="2.22.1";
    name="${baseName}-${version}";
    url="http://www.angelcode.com/angelscript/sdk/files/angelscript_${version}.zip";
    hash="0fmw0cb7ymgyq31r4cfvsn4k86r20hj650fbzs9i7zl0p3lb6hpm";
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
  phaseNames = ["prepareBuild" "doMake" "cleanLib" "doMakeInstall" "installDocs"];

  prepareBuild = a.fullDepEntry ''
    cd angelscript/projects/gnuc
    sed -i makefile -e "s@LOCAL = .*@LOCAL = $out@"
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
    description = "A light-weight scripting library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.zlib;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.angelcode.com/angelscript/downloads.asp";
    };
  };
}) x

