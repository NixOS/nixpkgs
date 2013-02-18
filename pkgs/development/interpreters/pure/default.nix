x@{builderDefsPackage
  , llvm, gmp, mpfr, readline, bison, flex
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
    version="0.56";
    name="${baseName}-${version}";
    extension="tar.gz";
    url="http://${project}.googlecode.com/files/${name}.${extension}";
    hash="1ll29j31lp7ymp1kq57328q8md7pkp8jmwsadp67j4cdlzc3zdhj";
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
  phaseNames = ["doPatch" "doConfigure" "doMakeInstall"];

  patches = [ ./new-gcc.patch ];

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

