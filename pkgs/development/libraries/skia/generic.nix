{ stdenv
, lib
, fetchgit
, expat
, fontconfig
, gn
, harfbuzzFull
, icu58
, libX11
, libGL
, libjpeg
, libpng
, libwebp
, ninja
, python3
, zlib

  # Specific versions pass these attributes:
, version
, rev
, hash
, depSrcs
, extraHeaders ? [ ]
}:

stdenv.mkDerivation {
  pname = "skia";
  inherit version;

  src = fetchgit {
    url = "https://skia.googlesource.com/skia.git";
    inherit rev hash;
  };

  nativeBuildInputs = [
    python3
    gn
    ninja
  ];

  buildInputs = [
    expat
    fontconfig
    harfbuzzFull
    icu58
    libX11
    libGL
    libjpeg
    libpng
    libwebp
    zlib
  ];

  postPatch = ''
    # Fix references to gn
    substituteInPlace gn/find_headers.py \
      --replace "gn              = sys.argv[1]" \
                "gn = '${gn}/bin/gn'"
  '';

  preConfigure = with depSrcs; ''
    mkdir -p third_party/externals
    ln -s ${angle2} third_party/externals/angle2
    ln -s ${dng_sdk} third_party/externals/dng_sdk
    ln -s ${piex} third_party/externals/piex
    ln -s ${sfntly} third_party/externals/sfntly
  '';

  gnFlags = [
    "is_debug=false"
    "is_official_build=true"
    "extra_cflags=[\"-I${harfbuzzFull.dev}/include/harfbuzz\"]"
    "skia_enable_tools=true"
  ];

  ninjaFlags = [
    "skia"
    "modules"
    "skia.h"
  ];

  installPhase = ''
    runHook preInstall

    # gnConfigurePhase leaves us in out/Release, go back up.
    cd ../..

    mkdir -p $out
    cp -r --parents -t $out/ \
      include \
      modules/*/include \
      modules/skottie/src/text/SkottieShaper.h \
      src/core/SkLRUCache.h \
      src/core/SkTInternalLList.h \
      src/utils/SkJSON.h \
      src/utils/SkJSONWriter.h \
      out/Release/libskia.a \
      out/Release/gen/skia.h
  '' + lib.optionalString (extraHeaders != []) ''
    cp --parents -t $out/ ${lib.escapeShellArgs extraHeaders}
  '' + ''

    runHook postInstall
  '';

  meta = with lib; {
    description = "2D graphics library for drawing text, geometries, and images";
    homepage = "https://skia.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
    platforms = platforms.all;
  };
}
