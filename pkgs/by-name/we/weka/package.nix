{
  lib,
  stdenv,
  fetchurl,
  openjdk11,
  unzip,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  xdg-utils,
  imagemagick,
  maxMemoryAllocationPool ? "1000M",
}:

stdenv.mkDerivation rec {
  pname = "weka";
  version = "3.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/weka/${lib.replaceStrings [ "." ] [ "-" ] "${pname}-${version}"}.zip";
    sha256 = "sha256-8fVN4MXYqXNEmyVtXh1IrauHTBZWgWG8AvsGI5Y9Aj0=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  # The -Xmx1000M comes suggested from their download page:
  # https://www.cs.waikato.ac.nz/ml/weka/downloading.html
  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/weka
    mkdir -p $out/share/icons/hicolor
    cp -Rv * $out/share/weka

    makeWrapper ${openjdk11}/bin/java $out/bin/weka \
      --add-flags "-Xmx${maxMemoryAllocationPool} -jar $out/share/weka/weka.jar"

    makeWrapper ${openjdk11}/bin/java $out/bin/weka-java \
      --add-flags "-Xmx${maxMemoryAllocationPool} -cp $out/share/weka/weka.jar"

    ${lib.optionalString stdenv.hostPlatform.isLinux "
        makeWrapper ${xdg-utils}/bin/xdg-open $out/bin/weka-doc --add-flags $out/share/weka/documentation.html
    "}

    cat << EOF > $out/bin/weka-home
    #!${stdenv.shell}
    echo -n $out/share/weka
    EOF

    chmod ugo+x $out/bin/weka-home

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      magick convert $out/share/weka/weka.gif -resize $size $out/share/icons/hicolor/$size/apps/weka.png
    done;

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "weka";
      exec = "weka";
      icon = "weka";
      desktopName = "WEKA";
      categories = [
        "Science"
        "ArtificialIntelligence"
        "ComputerScience"
      ];
    })

    (makeDesktopItem {
      name = "weka-doc";
      exec = "weka-doc";
      icon = "weka";
      desktopName = "View the WEKA documentation with a web browser";
      categories = [
        "Science"
        "ArtificialIntelligence"
        "ComputerScience"
      ];
    })
  ];

  meta = with lib; {
    homepage = "https://www.cs.waikato.ac.nz/ml/weka/";
    description = "Collection of machine learning algorithms for data mining tasks";
    mainProgram = "weka";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mimame ];
    platforms = platforms.unix;
  };
}
