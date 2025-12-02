{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  openjdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "visual-paradigm-ce";
  version = "17.3.20251201";

  src =
    let
      splitted = lib.versions.splitVersion finalAttrs.version;
      majorMinor = builtins.concatStringsSep "." (lib.dropEnd 1 splitted);
      suffix = lib.last splitted;
    in
    fetchurl {
      url = "https://eu10-dl.visual-paradigm.com/visual-paradigm/vpce${majorMinor}/${suffix}/Visual_Paradigm_CE_${
        builtins.replaceStrings [ "." ] [ "_" ] majorMinor
      }_${suffix}_Linux64_InstallFree.tar.gz";
      hash = "sha256-qHatD+W2SP9bLrOoIDXDNGdNKYoL52XdC6mVdelMFdc=";
    };

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "visualparadigm";
      desktopName = "Visual Paradigm";
      exec = "Visual_Paradigm %f";
      icon = "vpuml";
    })
    (makeDesktopItem {
      name = "visualparadigmproductselector";
      desktopName = "Visual Paradigm Product Selector";
      exec = "Visual_Paradigm_Product_Selector";
      icon = "ProductSelector";
    })
    (makeDesktopItem {
      name = "visualparadigmshapeeditor";
      desktopName = "Visual Paradigm Shape Editor";
      exec = "Visual_Paradigm_Shape_Editor";
      icon = "vpuml";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -D Application/resources/vpuml.png $out/share/icons/hicolor/512x512/apps/vpuml.png
    install -D Application/resources/ProductSelector.png $out/share/icons/hicolor/512x512/apps/ProductSelector.png

    mkdir -p $out/{bin,share/visual-paradigm-ce}
    mv {Application,.install4j} $out/share/visual-paradigm-ce/

    for bin in Visual_Paradigm Visual_Paradigm_Product_Selector Visual_Paradigm_Shape_Editor; do
      substituteInPlace $out/share/visual-paradigm-ce/Application/bin/$bin \
        --replace-fail '# INSTALL4J_JAVA_HOME_OVERRIDE=' "INSTALL4J_JAVA_HOME_OVERRIDE=${openjdk}" \
        --replace-fail 'app_home=../../' "app_home=${placeholder "out"}/share/visual-paradigm-ce"
      ln -s $out/share/visual-paradigm-ce/Application/bin/$bin $out/bin/
    done

    runHook postInstall
  '';

  meta = {
    description = "All-in-one UML CASE tool for software development";
    homepage = "https://www.visual-paradigm.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      drupol
      dvdznf
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    mainProgram = "Visual_Paradigm";
  };
})
