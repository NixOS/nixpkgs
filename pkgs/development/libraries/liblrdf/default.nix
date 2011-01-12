x@{builderDefsPackage
  , libtool, autoconf, automake, ladspaH, librdf_raptor, pkgconfig, zlib
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="liblrdf";
    version="0.4.0";
    project="lrdf";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/${project}/${baseName}/${version}/${name}.tar.gz";
    hash="015jv7pp0a0qxgljgdvf7d01nj4fx0zgzg0wayjp7v86pa38xscm";
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
    description = "Lightweight RDF library with special support for LADSPA";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
  };
}) x

