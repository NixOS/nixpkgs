x@{builderDefsPackage
  , llvm, gmp, mpfr, readline, bison, flex, makeWrapper
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
    version="0.58";
    name="${baseName}-${version}";
    extension="tar.gz";
    url="https://bitbucket.org/purelang/${project}/downloads/${name}.${extension}";
    hash="180ygv8nmfy8v4696km8jdahn5cnr454sc8i1av7s6z4ss7mrxmi";
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
  phaseNames = ["doConfigure" "doMakeInstall" "doWrap"];

  doWrap = a.makeManyWrappers ''$out/bin/pure'' ''--prefix LD_LIBRARY_PATH : "${llvm}/lib"'';

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
      downloadPage = "https://bitbucket.org/purelang/pure-lang/downloads";
    };
  };
}) x

