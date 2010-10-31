x@{builderDefsPackage
  , fetchgit
  , autoconf, automake, libtool
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchgit"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    method="fetchgit";
    baseName="libfixposix"; 
    url="git://gitorious.org/${baseName}/${baseName}";
    rev="30b75609d858588ea00b427015940351896867e9";
    version="git-${rev}";
    name="${baseName}-${version}";
    hash="44553c90d67f839cdd57d14d37d9faa25b1b766f607408896137f3013c1c9424";
  };
in
rec {
  srcDrv = a.fetchgit {
    url = sourceInfo.url;
    rev = sourceInfo.rev;
    sha256 = sourceInfo.hash;
  };

  src = srcDrv +"/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doAutoreconf" "doConfigure" "doMakeInstall"];

  doAutoreconf = a.fullDepEntry (''
    autoreconf -i
  '') ["doUnpack" "addInputs"];
      
  meta = {
    description = "A set of workarounds for places in POSIX that get implemented differently";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://gitorious.org/libfixposix/libfixposix";
    };
  };
}) x

