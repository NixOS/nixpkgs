x@{builderDefsPackage
  , intltool, openssl, expat, libgcrypt
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="ggz-base-libs";
    version="0.99.5";
    name="${baseName}-snapshot-${version}";
    url="http://mirrors.ibiblio.org/pub/mirrors/ggzgamingzone/ggz/snapshots/${name}.tar.gz";
    hash="1cw1vg0fbj36zyggnzidx9cbjwfc1yr4zqmsipxnvns7xa2awbdk";
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

  configureFlags = [
    "--with-ssl-dir=${a.openssl}/"
    "--with-tls"
  ];
      
  meta = {
    description = "GGZ Gaming zone libraries";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.ggzgamingzone.org/releases/";
    };
  };
}) x

