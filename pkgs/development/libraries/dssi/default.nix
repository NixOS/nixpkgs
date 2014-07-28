x@{builderDefsPackage
  , ladspaH, jackaudio, liblo, alsaLib, qt4, libX11, libsndfile, libSM
  , libsamplerate, libtool, autoconf, automake, xproto, libICE, pkgconfig
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="dssi";
    version="1.1.1";
    project="${baseName}";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/${project}/${baseName}/${version}/${name}.tar.gz";
    hash="0kl1hzhb7cykzkrqcqgq1dk4xcgrcxv0jja251aq4z4l783jpj7j";
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
    description = "A plugin SDK for virtual instruments";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl21;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/dssi/files/dssi/";
    };
  };
}) x

