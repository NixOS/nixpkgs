{
  lib,
  stdenv,
  fetchzip,
  jdk24,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  platform = selectSystem {
    "x86_64-linux" = "linux-x86-64";
  };

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

  nativeBuildInputs = [ copyDesktopItems ];

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

    mkdir -p $out/share/{applications,pixmaps}

    mv weasis-${platform}-jdk${lib.versions.major jdk24.version}-${finalAttrs.version}/Weasis/* $out/
    mv $out/lib/*.png $out/share/pixmaps/

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
