x@{builderDefsPackage
  , llvm, gmp, mpfr
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
    version="0.47";
    name="${baseName}-${version}";
    extension="tar.gz";
    url="http://${project}.googlecode.com/files/${name}.${extension}";
    hash="16j0k639kw2am4fc2h7q5sk7kx5z7nca896dakhphlb9zn9h0gbv";
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

