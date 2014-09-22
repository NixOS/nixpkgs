x@{builderDefsPackage
  , python
  , bzip2, zlib, gmp, openssl
  , boost
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = [ boost.lib ]
    ++ map (n: builtins.getAttr n x)
      (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="botan";
    tarBaseName="Botan";
    baseVersion = "1.10";
    revision = "8";
    version="${baseVersion}.${revision}";
    name="${baseName}-${version}";
    url="http://files.randombit.net/${baseName}/v${baseVersion}/${tarBaseName}-${version}.tbz";
    hash = "182f316rbdd6jrqn92vjms3jyb9syn4ic0nzi3b7rfjbj3zdabxw";
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
  phaseNames = ["doConfigure" "doMakeInstall" "fixPkgConfig"];
  configureCommand = "python configure.py --with-gnump --with-bzip2 --with-zlib --with-openssl --with-tr1-implementation=boost";

  fixPkgConfig = a.fullDepEntry ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '' ["minInit" "doMakeInstall"];
      
  meta = {
    description = "Cryptographic algorithms library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      unix;
    inherit version;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://files.randombit.net/botan/";
    };
  };
}) x
