x@{builderDefsPackage, fetchurl
  , autoconf, automake, libtool, m4
  , libX11, xproto, libXi, inputproto
  , libXaw, libXmu, libXt
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="ois";
    majorVersion="1";
    minorVersion="3";
    version="${majorVersion}.${minorVersion}";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/wgois/Source%20Release/${version}/ois_v${majorVersion}-${minorVersion}.tar.gz";
    hash="18gs6xxhbqb91x2gm95hh1pmakimqim1k9c65h7ah6g14zc7dyjh";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doPatch" "doConfigure" "doMakeInstall"];

  patches = [(fetchurl {
    url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/dev-games/ois/files/ois-1.3-gcc47.patch;
    sha256 = "026jw06n42bcrmg0sbdhzc4cqxsnf7fw30a2z9cigd9x282zhii8";
    name = "gcc47.patch";
  })];
  patchFlags = "-p0";

  configureCommand = ''sh bootstrap; sh configure'';

  meta = {
    description = "Object-oriented C++ input system";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.zlib;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/wgois/files/Source Release/";
    };
  };
}) x

