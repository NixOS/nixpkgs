
x@{builderDefsPackage
  , texinfo, libXext, xextproto, libX11, xproto, libXpm, libXt, libXcursor
  , alsaLib, cmake, zlib, libpng, libvorbis, libXxf86dga, libXxf86misc
  , xf86dgaproto, xf86miscproto, xf86vidmodeproto, libXxf86vm, openal, mesa
  , kbproto, libjpeg, flac, inputproto, libXi, fixesproto, libXfixes
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="allegro";
    folderSuffix = "-unstable";
    version = "5.1.11";
    name="${baseName}-${version}";
    project="alleg";
    url="mirror://sourceforge/project/${project}/${baseName}${folderSuffix}/${version}/${name}.tar.gz";
    hash="18fdppaqaf3g3rcqwhyvsmkzk3y14clz4l8cvmg4hvjgyf011f3i";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "0zz07gdyc6xflpvkknwgzsyyyh9qiwd69j42rm9cw1ciwcsic1vs";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["patchIncludes" "doCmake" "doMakeInstall"];

  patchIncludes = a.fullDepEntry ''
    sed -e 's@/XInput2.h@/XI2.h@g' -i CMakeLists.txt src/*.c
  '' ["minInit" "doUnpack"];

  doCmake = a.fullDepEntry (''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXext -lX11 -lXpm -lXcursor -lXxf86vm -lXi -lXfixes"
    cmake -D CMAKE_INSTALL_PREFIX=$out -D CMAKE_SKIP_RPATH=ON .
  '') ["minInit" "doUnpack" "addInputs"];

  makeFlags = [
  ];

  meta = {
    description = "A game programming library";
    license = a.lib.licenses.free; # giftware
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    inherit version;
  };
}) x
