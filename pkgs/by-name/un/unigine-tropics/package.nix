{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "unigine-tropics";
  version = "1.3";

  src = fetchurl {
    url = "https://assets.unigine.com/d/Unigine_Tropics-${finalAttrs.version}.run";
    hash = "sha256-/eA1i42/PMcoBbUJIGS66j7QpZ13oPkOi1Y6Q27TikU=";
  };

  libPath = lib.makeLibraryPath [
    pkgsi686Linux.libglvnd
    pkgsi686Linux.openal
    pkgsi686Linux.glibc
  ];

  installPhase = ''
    bash $src --target $name

    install -D -m 0755 $name/bin/libUnigine_x86.so $out/lib/unigine/tropics/bin/libUnigine_x86.so
    install -D -m 0755 $name/bin/Tropics $out/lib/unigine/tropics/bin/Tropics
    install -D -m 0755 $name/1024x768_windowed.sh $out/bin/Tropics

    cp -R $name/data $out/lib/unigine/tropics

    wrapProgram $out/bin/Tropics \
      --prefix LD_LIBRARY_PATH : $libPath:$out/lib/unigine/tropics/bin \
      --run "cd $out/lib/unigine/tropics"

    convert -size 256x256 xc:Transparent -fill gradient:'dodgerblue-white' -stroke Transparent -draw "roundrectangle 0,0 256,256 50,50"  $name/icon.png
    convert $name/icon.png -fill white -stroke white -draw "polygon  69.2564,84.1261 117.9,84.1261 117.9,206.56 138.1,206.56 138.1,84.1261 186.744,84.1261 186.744,65.9877 69.2564,65.9877 69.2564,84.1261" $name/icon.png

    for RES in 16 24 32 48 64 128 256
    do
        mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
        convert $name/icon.png -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/Tropics.png
    done
    convert $name/icon.png -resize 128x128 $out/share/icons/Tropics.png

    runHook postInstall
  '';

  desktopItems = [
    (pkgsi686Linux.makeDesktopItem {
      name = "Tropics";
      exec = "Tropics";
      genericName = "A GPU Stress test tool from the UNIGINE";
      icon = "Tropics";
      desktopName = "Tropics Benchmark";
    })
  ];

  nativeBuildInputs = [
    pkgsi686Linux.autoPatchelfHook
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.imagemagick
    pkgsi686Linux.copyDesktopItems
  ];

  buildInputs = [
    pkgsi686Linux.stdenv.cc.cc
    pkgsi686Linux.libx11
    pkgsi686Linux.libxext
    pkgsi686Linux.libxrandr
    pkgsi686Linux.libxinerama
  ];

  dontUnpack = true;

  meta = {
    description = "Unigine Heaven GPU benchmarking tool";
    homepage = "https://benchmark.unigine.com/tropics";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "Tropics";
  };
})
