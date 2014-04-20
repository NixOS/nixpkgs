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
    url="http://www.i18nguy.com/unicode/andagii.zip";
    name="andagii";
    version="1.0.2";
    hash="0cknb8vin15akz4ahpyayrpqyaygp9dgrx6qw7zs7d6iv9v59ds1";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    curlOpts = "--user-agent 'Mozilla/5.0'";
    sha256 = sourceInfo.hash;
  };

  name = "${sourceInfo.name}-${sourceInfo.version}";
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doUnpack" "doInstall"];

  doUnpack = a.fullDepEntry ''
    unzip "${src}"
  '' ["addInputs"];

  doInstall = a.fullDepEntry (''
    mkdir -p "$out"/share/fonts/ttf/
    cp ANDAGII_.TTF "$out"/share/fonts/ttf/andagii.ttf
  '') ["defEnsureDir" "minInit"];
      
  meta = {
    description = "Unicode Plane 1 Osmanya script font";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    hydraPlatforms = [];
    # There are multiple claims that the font is GPL, 
    # so I include the package; but I cannot find the
    # original source, so use it on your own risk
    # Debian claims it is GPL - good enough for me.
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.i18nguy.com/unicode/unicode-font.html";
    };
  };
}) x

