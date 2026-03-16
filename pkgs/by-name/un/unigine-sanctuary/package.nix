{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "unigine-sanctuary";
  version = "2.3";

  src = fetchurl {
    url = "https://assets.unigine.com/d/Unigine_Sanctuary-${version}.run";
    sha256 = "sha256-KKi70ctkEm+tx0kjBMWVKMLDrJ1TsPH+CKLDMXA6OdU=";
  };

  libPath = lib.makeLibraryPath [
    pkgsi686Linux.libglvnd
    pkgsi686Linux.openal
    pkgsi686Linux.glibc
  ];

  installPhase = ''
    bash $src --target ${pname}-${version}

    install -D -m 0755 ${pname}-${version}/bin/libUnigine_x86.so $out/lib/unigine/sanctuary/bin/libUnigine_x86.so
    install -D -m 0755 ${pname}-${version}/bin/Sanctuary $out/lib/unigine/sanctuary/bin/Sanctuary
    install -D -m 0755 ${pname}-${version}/1024x768_windowed.sh $out/bin/Sanctuary

    cp -R ${pname}-${version}/data $out/lib/unigine/sanctuary

    wrapProgram $out/bin/Sanctuary \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/lib/unigine/sanctuary/bin \
      --run "cd $out/lib/unigine/sanctuary"

    convert -size 256x256 xc:Transparent -define gradient:center="128,128" -define gradient:vector="128,128 128,128" \
      -define gradient:radii="128,128" -fill radial-gradient:'rgb(164,0,0)-rgb(67,1,3)' \
      -draw "roundRectangle 0,0 256,256 50,50" ${pname}-${version}/icon.png
    convert ${pname}-${version}/icon.png -size 181.991x181.991 -font ${pkgsi686Linux.liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf \
      -pointsize 181.991 -define gradient:center="128,128" -define gradient:vector="128,128 128,128" \
      -define gradient:radii="46.6974,46.6974" -fill radial-gradient:'rgb(249,197,46)-rgb(218,144,31)' \
      -stroke none -strokewidth 4.54977 -draw 'text 69.3061,194.247 "S"' ${pname}-${version}/icon.png

    for RES in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
      convert ${pname}-${version}/icon.png -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/Sanctuary.png
    done
    convert ${pname}-${version}/icon.png -resize 128x128 $out/share/icons/Sanctuary.png

    runHook postInstall
  '';

  desktopItems = [
    (pkgsi686Linux.makeDesktopItem {
      name = "Sanctuary";
      exec = "Sanctuary";
      genericName = "A GPU Stress test tool from the UNIGINE";
      icon = "Sanctuary";
      desktopName = "Sanctuary Benchmark";
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
    homepage = "https://benchmark.unigine.com/sanctuary";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "Sanctuary";
  };
}
