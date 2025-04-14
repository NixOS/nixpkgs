{
  lib,
  stdenv,
  fetchzip,
  jdk24,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  libGL,
  xorg,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  platform = selectSystem {
    "x86_64-linux" = "linux-x86-64";
  };

  runtimeDeps = [
    libGL
  ]
  ++ (with xorg; [
    libX11
    libXrender
    libXxf86vm
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "weasis";
  version = "4.6.1";

  # Their build instructions indicate to use the packaging script
  src = fetchzip {
    url = "https://github.com/nroduit/Weasis/releases/download/v${finalAttrs.version}/weasis-native.zip";
    hash = "sha256-poBMlSjaT4Mx4CV/19S7Dzk48RsgeKrBxl9KXRDzWrc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "DICOMizer";
      exec = "Dicomizer";
      icon = "Dicomizer";
      desktopName = "DICOMizer";
      comment = "Convert standard images into DICOM";
    })
    (makeDesktopItem {
      name = "Weasis";
      exec = "Weasis";
      icon = "Weasis";
      desktopName = "Weasis";
      comment = finalAttrs.meta.description;
    })
  ];

  postPatch = ''
    patchShebangs ./build/script/package-weasis.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build/script/package-weasis.sh --no-installer --jdk ${jdk24}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/Weasis/share/{applications,pixmaps}}

    mv weasis-${platform}-jdk${lib.versions.major jdk24.version}-${finalAttrs.version}/Weasis/* $out/opt/Weasis
    mv $out/opt/Weasis/lib/*.png $out/opt/Weasis/share/pixmaps/

    for bin in $out/opt/Weasis/bin/*; do
      makeWrapper $bin $out/bin/$(basename $bin) \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeDeps}
    done

    runHook postInstall
  '';

  meta = {
    description = "Multipurpose standalone and web-based DICOM viewer with a highly modular architecture";
    homepage = "https://weasis.org";
    # Using changelog from releases as it is more accurate
    changelog = "https://github.com/nroduit/Weasis/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Weasis";
  };
})
