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
    baseVersion = "1.11";
    revision = "9";
    version="${baseVersion}.${revision}";
    name="${baseName}-${version}";
    url="http://files.randombit.net/${baseName}/v${baseVersion}/${tarBaseName}-${version}.tbz";
    hash = "0jgx5va042gmr6nc91p5dd59wnfxlz19mz2nnyv74pvwwmizs09m";
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
  configureCommand = "python configure.py --with-gnump --with-bzip2 --with-zlib --with-openssl";

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
