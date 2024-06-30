{ lib
, stdenv
, tde
, coreutils
, cups
, fontconfig
, freetype
, libGL
, libGLU
, libSM
, libX11
, libXcursor
, libXext
, libXft
, libXinerama
, libXmu
, libXrandr
, libXrender
, libjpeg
, libmng
, libpng
, libuuid
, mesa
, pkg-config
, sqlite
, which
, xorgproto
, zlib

, cupsSupport ? false
, openGLSupport ? true
, smSupport ? true
, sqliteSupport ? false
, threadSupport ? true
, xcursorSupport ? true
, xextSupport ? true
, xftSupport ? true
, xineramaSupport ? true
, xkbSupport ? true
, xrandrSupport ? true
, xrenderSupport ? true
, xshapeSupport ? true
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (tde.mkTDEComponent tde.sources.tqt3)
    pname version src;

  nativeBuildInputs = [
    pkg-config
    which
  ];

  propagatedBuildInputs = [
    coreutils
    libjpeg
    libmng
    libpng
    libuuid
    zlib
  ]
  ++ lib.optionals cupsSupport [ cups ]
  ++ lib.optionals openGLSupport [ libGL libGLU libXmu ]
  ++ lib.optionals smSupport [ libSM ]
  ++ lib.optionals sqliteSupport [ sqlite ]
  ++ lib.optionals xcursorSupport [ libXcursor ]
  ++ lib.optionals xftSupport [ fontconfig freetype libXft ]
  ++ lib.optionals xineramaSupport [ libXinerama ]
  ++ lib.optionals xkbSupport [ libX11 ]
  ++ lib.optionals xrandrSupport [ libXrandr ]
  ++ lib.optionals xrandrSupport [ libXrandr xorgproto ]
  ++ lib.optionals xrenderSupport [ libXrender ]
  ++ lib.optionals xshapeSupport [ libXext ]
  ;

  postPatch = ''
    substituteInPlace configure \
      --replace "/bin/pwd" "pwd"
    for file in config.tests/unix/checkavail \
                config.tests/*/*.test \
                mkspecs/*/qmake.conf; do
      echo "Preprocessing $file..."
      substituteInPlace "$file" \
        --replace " /lib" " /INEXISTENT-LIB" \
        --replace "/usr" "/INEXISTENT-USR"
    done
  '';

  dontAddPrefix = true; # because the script doesn't use double-dash convention

  configureFlags = let
    selectFlags = condition: libraries: extraFlags:
      lib.optionals condition
        ((map (l: [
          "-L${lib.getLib l}/lib"
          "-I${lib.getDev l}/include"
        ]) libraries)
        ++ extraFlags);
  in [
    "-verbose"
    "-continue"
    "-prefix ${placeholder "out"}"
    "${lib.optionalString (!threadSupport) "-no"}-thread"
    "-no-exceptions"
    "-qt-gif"
    "-system-zlib"
  ]
  ++ [
    "-qt-imgfmt-jpeg" "-system-libjpeg"
    "-qt-imgfmt-mng" "-system-libmng"
    "-qt-imgfmt-png" "-system-libpng"
  ]
  ++ (if stdenv.hostPlatform.isStatic
      then [ "-static" ]
      else [ "-shared" ])
  ++ (selectFlags cupsSupport [ cups ] [ "-cups" ])
  ++ (selectFlags openGLSupport [ libGL libGLU libXmu ] [ "-enable-opengl" ])
  ++ (selectFlags smSupport [ libSM ] [ "-sm" "-lSM" "-lICE" ])
  ++ (selectFlags sqliteSupport [ sqlite ] [ "-lsqlite3" "-qt-sql-sqlite" ])
  ++ (selectFlags xcursorSupport [ libXcursor ] [ "-xcursor" ])
  ++ (selectFlags xftSupport [ fontconfig freetype libXft ] [ "-xft" ])
  ++ (selectFlags xineramaSupport [ libXinerama ] [ "-xinerama" ])
  ++ (selectFlags xkbSupport [ libX11 ] [ "-lX11" "-xkb" ])
  ++ (selectFlags xrandrSupport [ libXrandr ] [ "-xrandr" ])
  ++ (selectFlags xrandrSupport [ libXrandr xorgproto ] [ "-xft" ])
  ++ (selectFlags xrenderSupport [ libXrender ] [ "-xrender" ])
  ++ (selectFlags xshapeSupport [ libXext ] [ "-xshape" ])
  ;

  postConfigure = ''
    export LD_LIBRARY_PATH=$(pwd)/lib
  '';

  # Workaround for a compilation 'error'
  hardeningDisable = [ "all" ];

  setupHook = ./setup-hook.sh;

  meta = (tde.mkTDEComponent tde.sources.tqt3).meta;
})
# INFO: autotool build, will be converted by cmake in the future
# TODO: set -platform and -xplatform
