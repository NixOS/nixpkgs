{ stdenv
, lib
, fetchgit
, expat
, fontconfig
, gn
, harfbuzzFull
, icu58
, libX11
, libglvnd
, libjpeg
, libpng
, libwebp
, mesa
, ninja
, python3
, zlib

  # Specific versions pass these attributes:
, version
, rev
, hash
, depSrcs
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
    libglvnd
    libjpeg
    libpng
    libwebp
    mesa
    zlib
  ];

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
  ];

  ninjaFlags = [
    "skia"
    "modules"
  ];

  installPhase = ''
    runHook preInstall

    # gnConfigurePhase leaves us in out/Release, go back up.
    cd ../..

    mkdir -p $out
    cp -r --parents -t $out/ \
      include \
      out/Release/libskia.a

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
