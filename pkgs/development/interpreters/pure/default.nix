x@{builderDefsPackage
  , llvm, gmp, mpfr, readline
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="pure";
    project="pure-lang";
    version="0.49";
    name="${baseName}-${version}";
    extension="tar.gz";
    url="http://${project}.googlecode.com/files/${name}.${extension}";
    hash="0kkrcmmqks82g3qlkvs3cd23v6b5948rw3xsdadd1jidh74jg33x";
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
    description = "A purely functional programming language based on term rewriting";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl3Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/pure-lang/downloads/list";
    };
  };
}) x

