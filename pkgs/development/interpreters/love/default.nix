x@{builderDefsPackage
  , lua5, mpg123, physfs, freetype, libdevil, openal, SDL, libvorbis
  , libogg, flac, mesa, libtiff, libpng, libjpeg, libmodplug
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="love";
    version="0.7.2";
    name="${baseName}-${version}";
    url="https://bitbucket.org/rude/love/downloads/${name}-linux-src.tar.gz";
    hash="0s7jywkvydlshlgy11ilzngrnybmq5xlgzp2v2dhlffwrfqdqym5";
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
  phaseNames = ["setVars" "fixSrc" "doConfigure" "doMakeInstall"];
      
  fixSrc  =a.fullDepEntry ''
    sed -e '/typedef void (\*__GLXextFuncPtr)/d' -i src/modules/graphics/opengl/GLee.h
  '' ["minInit" "doUnpack"];

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL}/include/SDL"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
  '';

  meta = {
    description = "A Lua-based 2D game engine/scripting language";
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
      downloadPage = "http://love2d.org/";
    };
  };
}) x

