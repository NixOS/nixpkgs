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

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="botan";
    tarBaseName="Botan";
    baseVersion="1.8";
    revision="11";
    version="${baseVersion}.${revision}";
    name="${baseName}-${version}";
    url="http://files.randombit.net/${baseName}/v${baseVersion}/${tarBaseName}-${version}.tbz";
    hash="194vffc9gfb0912lzndn8nzblg2d2gjmk13fc8hppgpw7ln0mdn3";
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
  configureCommand = "python configure.py --with-gnump --with-bzip2 --with-zlib --with-openssl --with-tr1-implementation=boost";
      
  meta = {
    description = "Cryptographic algorithms library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      unix;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://files.randombit.net/botan/";
    };
  };
}) x
